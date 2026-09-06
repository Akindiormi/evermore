import 'package:url_launcher/url_launcher.dart';
import '../config/app_config.dart';

class TelegramService {
  static const communityUrl = AppConfig.telegramUrl;

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
}
