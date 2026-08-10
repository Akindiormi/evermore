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

      - name: Create Android platform files if missing
        run: flutter create . --platforms=android --project-name evermore

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
          test -n "$KEYSTORE_BASE64" || (echo "Missing EVERMORE_KEYSTORE_BASE64" && exit 1)
          test -n "$KEYSTORE_PASSWORD" || (echo "Missing EVERMORE_KEYSTORE_PASSWORD" && exit 1)
          test -n "$KEY_ALIAS" || (echo "Missing EVERMORE_KEY_ALIAS" && exit 1)
          test -n "$KEY_PASSWORD" || (echo "Missing EVERMORE_KEY_PASSWORD" && exit 1)

          mkdir -p android/app/keystore
          echo "$KEYSTORE_BASE64" | base64 --decode > android/app/keystore/evermore-upload-keystore.jks

          cat > android/key.properties <<EOF
          storePassword=$KEYSTORE_PASSWORD
          keyPassword=$KEY_PASSWORD
          keyAlias=$KEY_ALIAS
          storeFile=keystore/evermore-upload-keystore.jks
          EOF

      - name: Configure Android release signing
        run: |
          python3 - <<'PY'
          from pathlib import Path

          path = Path("android/app/build.gradle.kts")
          text = path.read_text()

          if 'signingConfigs.create("release")' not in text:
              marker = "android {"
              signing = (
                  'android {\n'
                  '    val keystorePropertiesFile = rootProject.file("key.properties")\n'
                  '    val keystoreProperties = java.util.Properties()\n'
                  '    if (keystorePropertiesFile.exists()) {\n'
                  '        keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }\n'
                  '    }\n\
