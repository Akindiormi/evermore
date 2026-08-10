import 'package:url_launcher/url_launcher.dart';

class TelegramService {
  static const communityUrl = 'https://t.me/evermorecommunity';

  static Future<void> openCommunity() async {
    final uri = Uri.parse(communityUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
