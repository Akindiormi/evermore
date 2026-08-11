import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
import '../../core/widgets/evermore_background.dart';
import '../../core/widgets/evermore_mark.dart';
import '../../services/telegram_service.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  static const items = [
    (Icons.forum_outlined, 'Weekly discussions', 'Talk through ideas, lessons and real-life growth situations.'),
    (Icons.track_changes_outlined, 'Growth challenges', 'Take what you learn inside the app and apply it with other members.'),
    (Icons.groups_outlined, 'Accountability sessions', 'Check in with the community and stay committed to your goals.'),
    (Icons.campaign_outlined, 'Community announcements', 'Stay informed about new programs, events and opportunities.'),
    (Icons.live_tv_outlined, 'Live sessions', 'Join practical conversations and learning sessions.'),
  ];

  Future<void> _join(BuildContext context) async {
    final opened = await TelegramService.openCommunity();
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Telegram could not be opened. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return EvermoreBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 125),
          children: [
            const Text('Community', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800, letterSpacing: -.8)),
            const SizedBox(height: 7),
            const Text('The people layer of Evermore. Learn together, stay accountable and keep moving.', style: TextStyle(color: EvermoreTheme.muted, height: 1.45, fontSize: 13.5)),
            const SizedBox(height: 22),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _join(context),
                borderRadius: BorderRadius.circular(29),
                child: Ink(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(gradient: EvermoreTheme.heroGradient, borderRadius: BorderRadius.circular(29), boxShadow: EvermoreTheme.cardShadow),
                  child: Stack(children: [
                    const Positioned(right: -8, top: -10, child: Opacity(opacity: .12, child: EvermoreMark(size: 105, color: Colors.white))),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .15), shape: BoxShape.circle), child: const Icon(Icons.groups_rounded, color: Colors.white)),
                      const SizedBox(height: 17),
                      const Text('Your growth should not happen alone.', style: TextStyle(color: Colors.white, fontSize: 24, height: 1.08, fontWeight: FontWeight.w800, letterSpacing: -.5)),
                      const SizedBox(height: 10),
                      const Text('Join the Evermore Telegram community for discussions, accountability and live sessions.', style: TextStyle(color: Colors.white70, height: 1.45, fontSize: 12)),
                      const SizedBox(height: 18),
                      Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.send_rounded, color: EvermoreTheme.primary, size: 18),
                          SizedBox(width: 8),
                          Text('Join Telegram', style: TextStyle(color: EvermoreTheme.primary, fontWeight: FontWeight.w900, fontSize: 13)),
                          SizedBox(width: 7),
                          Icon(Icons.arrow_outward_rounded, color: EvermoreTheme.primary, size: 16),
                        ]),
                      ),
                    ]),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 27),
            const Text("What's happening", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 11),
            ...items.map((item) => _CommunityItem(icon: item.$1, title: item.$2, subtitle: item.$3, onTap: () => _join(context))),
          ],
        ),
      ),
    );
  }
}

class _CommunityItem extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const _CommunityItem({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: EvermoreTheme.glassCard(radius: 20, color: Colors.white.withValues(alpha: .72)),
          child: Row(children: [
            Container(width: 43, height: 43, decoration: BoxDecoration(gradient: EvermoreTheme.softGradient, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: EvermoreTheme.primary, size: 19)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 10.5, height: 1.35, color: EvermoreTheme.muted)),
            ])),
            const Icon(Icons.arrow_outward_rounded, size: 17, color: EvermoreTheme.primary),
          ]),
        ),
      ),
    ),
  );
}
