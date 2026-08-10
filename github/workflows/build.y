name: Build Evermore Android

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.32.8"
          channel: stable
          cache: true

      - name: Create Android platform files
        run: |
          flutter create . \
            --platforms=android \
            --project-name evermore \
            --org com.evermore

      - name: Get packages
        run: flutter pub get

      - name: Prepare release keystore
        env:
          KEYSTORE_BASE64: ${{ secrets.EVERMORE_KEYSTORE_BASE64 }}
          KEYSTORE_PASSWORD: ${{ secrets.EVERMORE_KEYSTORE_PASSWORD }}
          KEY_ALIAS: ${{ secrets.EVERMORE_KEY_ALIAS }}
          KEY_PASSWORD: ${{ secrets.EVERMORE_KEY_PASSWORD }}
        run: |
          set -euo pipefail

          test -n "$KEYSTORE_BASE64" || {
            echo "Missing EVERMORE_KEYSTORE_BASE64"
            exit 1
          }

          test -n "$KEYSTORE_PASSWORD" || {
            echo "Missing EVERMORE_KEYSTORE_PASSWORD"
            exit 1
          }

          test -n "$KEY_ALIAS" || {
            echo "Missing EVERMORE_KEY_ALIAS"
            exit 1
          }

          test -n "$KEY_PASSWORD" || {
            echo "Missing EVERMORE_KEY_PASSWORD"
            exit 1
          }

          mkdir -p android/app/keystore

          echo "$KEYSTORE_BASE64" | base64 --decode \
            > android/app/keystore/evermore-upload-keystore.jks

          cat > android/key.properties <<EOF
          storePassword=$KEYSTORE_PASSWORD
          keyPassword=$KEY_PASSWORD
          keyAlias=$KEY_ALIAS
          storeFile=keystore/evermore-upload-keystore.jks
          EOF

      - name: Configure release signing
        run: |
          python3 - <<'PY'
          from pathlib import Path

          path = Path("android/app/build.gradle.kts")
          text = path.read_text()

          if 'signingConfigs.create("release")' not in text:
              signing_block = '''
              val keystorePropertiesFile = rootProject.file("key.properties")
              val keystoreProperties = java.util.Properties()

              if (keystorePropertiesFile.exists()) {
                  keystorePropertiesFile.inputStream().use {
                      keystoreProperties.load(it)
                  }
              }

              signingConfigs {
                  create("release") {
                      keyAlias = keystoreProperties["keyAlias"] as String?
                      keyPassword = keystoreProperties["keyPassword"] as String?
                      storeFile = keystoreProperties["storeFile"]?.let {
                          rootProject.file(it)
                      }
                      storePassword = keystoreProperties["storePassword"] as String?
                  }
              }
              '''

              text = text.replace(
                  'android {',
                  'android {\\n' + signing_block,
                  1
              )

          text = text.replace(
              'signingConfig = signingConfigs.getByName("debug")',
              'signingConfig = signingConfigs.getByName("release")'
          )

          if 'signingConfig = signingConfigs.getByName("release")' not in text:
              text = text.replace(
                  'buildTypes {',
                  '''buildTypes {
                      release {
                          signingConfig =
                              signingConfigs.getByName("release")
                      }''',
                  1
              )

          path.write_text(text)
          PY

      - name: Analyze Flutter project
        run: flutter analyze

      - name: Build release APK
        run: flutter build apk --release

      - name: Build release AAB
        run: flutter build appbundle --release

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: evermore-release-apk
          path: build/app/outputs/flutter-apk/app-release.apk

      - name: Upload AAB
        uses: actions/upload-artifact@v4
        with:
          name: evermore-release-aab
          path: build/app/outputs/bundle/release/app-release.aab

      - name: Clean signing files
        if: always()
        run: |
          rm -f android/key.properties
          rm -f android/app/keystore/evermore-upload-keystore.jks
