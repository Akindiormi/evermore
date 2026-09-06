# Evermore

Evermore is a native Flutter mobile experience built around the Evermore ecosystem: learn practical skills, engage with verified opportunities, and build progress and earnings.

## Product experience

The app is intentionally native Flutter. The Evermore website is a product and brand reference, not an embedded website or WebView.

Core areas:
- Home dashboard
- EverAI
- Click n Earn
- EverMusic
- Evermore Academy
- Wallet and earnings activity
- Community access
- Profile and account settings

## Onboarding

1. Welcome
2. Email/password account creation
3. Optional referral code
4. Telegram community invitation (skippable)
5. Personalized interests
6. Home dashboard

Phone-number signup and OTP onboarding are not used in the current experience.

## Design

The visual direction follows Evermore's blue brand language and the website's clean digital-product feel, combined with the app's premium light/glass-inspired system, strong typography, soft surfaces, rounded cards, subtle gradients, motion-ready layouts, and consistent iconography. Emoji are intentionally not used in the product UI.

## Android identity

The Evermore brand is a rebrand/upgrade of the existing Play application. The Android application identity must remain:

`com.earnpalsolutions.earnpal`

The release workflow preserves this application ID and namespace and continues to use the existing Evermore release-signing secrets.

## Build

Run:

```bash
flutter pub get
dart run flutter_launcher_icons
flutter analyze
flutter build appbundle --release
```

GitHub Actions prepares the Android project, enforces the preserved application identity, configures Android API/NDK versions, signs release builds, and uploads APK/AAB artifacts.

## Important product rule

The UI may use illustrative empty-state values such as a zero starting balance, but real earnings, task completion, verification, withdrawals, and account data must come from the production backend rather than being hardcoded into the client.
