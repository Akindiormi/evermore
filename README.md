# Evermore

Evermore is a practical personal growth program delivered through a learning app and a Telegram community.

## Program

10 pillars, 5 lessons each:

1. Self-Awareness
2. Mindset & Resilience
3. Productivity
4. Communication
5. Financial Literacy
6. Career Growth
7. Digital Skills
8. Leadership
9. Goals & Strategy
10. Discipline & Execution

The product flow is:

Onboarding → Growth Path → 10 Pillars → Lessons → Reflection → Action → XP / Streak → Challenges → Community

## Community

Telegram is the social layer while the app remains the learning/program layer.

Community areas:
- Weekly discussions
- Growth challenges
- Accountability sessions
- Community announcements
- Live sessions

The current Telegram destination is intentionally left as the placeholder:
`https://t.me/evermorecommunity`

Replace it later with the real community URL.

## Design

Evermore uses a blue visual system based on the supplied Evermore icon and Plus Jakarta Sans.

## Build

Run:

```bash
flutter pub get
dart run flutter_launcher_icons
flutter analyze
flutter build appbundle --release
```

The GitHub Actions workflow also prepares Android files and handles release signing through GitHub repository secrets.

## Privacy policy

No privacy-policy URL is included yet. Add the real policy URL before Play Store submission.
