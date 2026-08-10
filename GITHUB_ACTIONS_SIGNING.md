# Evermore GitHub Actions signing

The release workflow is configured to use the Evermore upload keystore through GitHub Actions secrets.

Create these four repository secrets:

- `EVERMORE_KEYSTORE_BASE64` — paste the complete Base64 contents of the keystore file.
- `EVERMORE_KEYSTORE_PASSWORD` — the keystore Store password.
- `EVERMORE_KEY_ALIAS` — `evermore`
- `EVERMORE_KEY_PASSWORD` — the key password.

The keystore itself is intentionally NOT included in this ZIP or repository.

The workflow creates Android platform files when needed, restores the keystore from the secret, signs the release, builds the APK and AAB, uploads both as workflow artifacts, and removes temporary signing material.

Do not commit:
- `.jks` files
- Base64 keystore files
- passwords
- `android/key.properties`
