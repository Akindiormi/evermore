import '../models/app_package.dart';

class AppConfig {
  static const telegramUrl = 'https://t.me/earnpalnet';

  // Replace these placeholders with the real payment destination before launch.
  static const bankName = 'BANK NAME — CONFIGURE BEFORE LAUNCH';
  static const accountName = 'ACCOUNT NAME — CONFIGURE BEFORE LAUNCH';
  static const accountNumber = '0000000000';
  static const paymentInstructions = 'Transfer the exact package amount, keep your receipt, then submit the receipt below. Payment remains pending until it is independently confirmed.';

  static const packages = <AppPackage>[
    AppPackage(
      id: 'standard',
      name: 'Standard',
      priceNaira: 7000,
      description: 'A practical starting package for learning and platform access.',
      benefits: ['Learning catalogue access', 'Community access', 'Core platform features'],
    ),
    AppPackage(
      id: 'premium',
      name: 'Premium',
      priceNaira: 14000,
      description: 'Expanded access for members who want the full learning experience.',
      benefits: ['Everything in Standard', 'Premium learning content', 'Additional platform features'],
    ),
  ];
}
