import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
import '../../services/telegram_service.dart';
import '../../widgets/neo_pill_button.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.forum_outlined, 'Weekly discussions', 'Talk through ideas, lessons and real-life growth situations.'),
      (Icons.track_changes_outlined, 'Growth challenges', 'Take what you learn inside the app and apply it with other members.'),
      (Icons.groups_outlined, 'Accountability sessions', 'Check in with the community and stay committed to your goals.'),
      (Icons.campaign_outlined, 'Community announcements', 'Stay informed about new programs, events and opportunities.'),
      (Icons.live_tv_outlined, 'Live sessions', 'Join practical conversations and learning sessions.'),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
        children: [
          const Text('Community', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 7),
          const Text('The people layer of Evermore. Learn together, stay accountable and keep moving.', style: TextStyle(color: EvermoreTheme.muted, height: 1.45)),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [EvermoreTheme.primary, EvermoreTheme.primaryDark]), borderRadius: BorderRadius.circular(24)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.groups_outlined, color: Colors.white, size: 30),
              const SizedBox(height: 16),
              const Text('Your growth should not happen alone.', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800, height: 1.15)),
              const SizedBox(height: 10),
              const Text('Join the Evermore Telegram community for discussions, accountability and live sessions.', style: TextStyle(color: Colors.white70, height: 1.5, fontSize: 13)),
              const SizedBox(height: 19),
              NeoPillButton(
                label: 'Join Telegram',
                onPressed: TelegramService.openCommunity,
                fillColor: Colors.white,
                shadowColor: EvermoreTheme.primaryTint,
                textColor: EvermoreTheme.primary,
              ),
            ]),
          ),
          const SizedBox(height: 25),
          const Text("What's happening", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ...items.map((item) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: EvermoreTheme.border)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: EvermoreTheme.primary.withValues(alpha: .08), borderRadius: BorderRadius.circular(12)),
                child: Icon(item.$1, color: EvermoreTheme.primary, size: 19)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.$2, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                const SizedBox(height: 4),
                Text(item.$3, style: const TextStyle(fontSize: 11, height: 1.4, color: EvermoreTheme.muted)),
              ])),
            ]),
          )),
        ],
      ),
    );
  }
}
