import 'package:url_launcher/url_launcher.dart';

class TelegramService {
  static const communityUrl = 'https://t.me/evermorecommunity';

  static Future<bool> openCommunity() async {
    final uri = Uri.parse(communityUrl);
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
