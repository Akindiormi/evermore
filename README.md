# Liora

Liora is a membership-based digital platform. **Discover more. Become more.**

The platform experience is organized around:
- Member accounts and membership access
- Surveys
- Games
- Videos
- Activities

## Membership

- Active: ₦7,000
- Premium: ₦14,000

Membership pricing is displayed as supplied by the product owner. Payment processing, membership activation, and account security must be connected to a real backend/payment provider before accepting live members. Rewards and earnings are not live and must not be advertised as available until the underlying program is implemented and funded.

## Flutter Web

```bash
flutter pub get
flutter config --enable-web
flutter build web --release
```

The GitHub Actions workflow builds the web bundle and uploads it as the `liora-web-build` artifact. Hosting and a production domain still need to be configured.

## Current implementation status

The new web-first Liora shell is a frontend foundation. Survey/game/video/activity content, secure server-side authentication, membership payments, admin tools, and rewards logic require backend implementation and configuration. The legacy personal-growth content is no longer part of the Liora product direction.
