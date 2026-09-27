import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';

class TelegramService {
  static const communityUrl = AppConfig.telegramUrl;

  static String activationMessage({
    required String name,
    required String email,
    required String phone,
    required String country,
  }) {
    return '''NEW ACCOUNT ACTIVATION

Full name: $name
Email: $email
Phone: $phone
Country: $country
Account status: Pending activation''';
  }

  static Future<bool> openCommunity() async {
    final uri = Uri.parse(communityUrl);
    try {
      if (await canLaunchUrl(uri)) {
        return launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> openActivationDraft({
    required String name,
    required String email,
    required String phone,
    required String country,
  }) async {
    final message = activationMessage(
      name: name,
      email: email,
      phone: phone,
      country: country,
    );
    final uri = Uri.parse(communityUrl).replace(queryParameters: {
      'text': message,
    });
    try {
      if (await canLaunchUrl(uri)) {
        return launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {
      return false;
    }
  }
}
