import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
import '../../services/progress_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int xp = 0, streak = 0, lessons = 0, challenges = 0;
  List<String> goals = [];

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final service = ProgressService();
    final l = await service.completedLessons();
    final c = await service.completedChallenges();
    final g = await service.getGoals();
    final loadedXp = await service.getXp();
    final loadedStreak = await service.getStreak();
    if (mounted) setState(() { xp = loadedXp; streak = loadedStreak; lessons = l.length; challenges = c.length; goals = g; });
  }

  int serviceValue(int value) => value;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
        children: [
          const Text('My growth', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 7),
          const Text('Your progress through the Evermore program.', style: TextStyle(color: EvermoreTheme.muted)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(23), border: Border.all(color: EvermoreTheme.border)),
            child: Column(children: [
              Container(width: 72, height: 72, decoration: BoxDecoration(color: EvermoreTheme.primary.withValues(alpha: .08), shape: BoxShape.circle),
                child: const Icon(Icons.person_outline_rounded, color: EvermoreTheme.primary, size: 34)),
              const SizedBox(height: 13),
              const Text('Evermore member', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
              const SizedBox(height: 5),
              const Text('Keep learning. Keep applying. Keep becoming.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: EvermoreTheme.muted)),
            ]),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _StatCard(Icons.bolt_outlined, '$xp', 'XP')),
            const SizedBox(width: 10),
            Expanded(child: _StatCard(Icons.local_fire_department_outlined, '$streak', 'Day streak')),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _StatCard(Icons.menu_book_outlined, '$lessons', 'Lessons')),
            const SizedBox(width: 10),
            Expanded(child: _StatCard(Icons.track_changes_outlined, '$challenges', 'Challenges')),
          ]),
          const SizedBox(height: 25),
          const Text('My focus areas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: goals.map((g) => Chip(label: Text(g))).toList()),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: EvermoreTheme.primary.withValues(alpha: .06), borderRadius: BorderRadius.circular(19)),
            child: const Text('Growth is not one big transformation. It is the result of learning, applying, reflecting and repeating.', style: TextStyle(fontSize: 13, height: 1.55)),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatCard(this.icon, this.value, this.label);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: EvermoreTheme.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 18, color: EvermoreTheme.primary),
      const SizedBox(height: 12),
      Text(value, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 10, color: EvermoreTheme.muted)),
    ]),
  );
}
