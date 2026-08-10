import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
import '../../data/growth_data.dart';
import '../../data/challenge_data.dart';
import '../../services/progress_service.dart';
import '../learn/learn_screen.dart';
import '../lesson/lesson_detail_screen.dart';
import '../challenges/challenges_screen.dart';
import '../community/community_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int xp = 0, streak = 0, completedLessons = 0;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final service = ProgressService();
    final l = await service.completedLessons();
    final loadedXp = await service.getXp();
    final loadedStreak = await service.getStreak();
    if (mounted) setState(() { xp = loadedXp; streak = loadedStreak; completedLessons = l.length; });
  }

  int serviceValue(int value) => value;

  @override
  Widget build(BuildContext context) {
    final totalLessons = growthPillars.expand((p) => p.lessons).length;
    final currentPillar = growthPillars[(completedLessons ~/ 5).clamp(0, growthPillars.length - 1)];
    final nextLesson = currentPillar.lessons[completedLessons % currentPillar.lessons.length];

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
          children: [
            Row(children: [
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('EVERMORE', style: TextStyle(fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w800, color: EvermoreTheme.primary)),
                SizedBox(height: 5),
                Text('Keep becoming.', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800)),
              ])),
              _MiniStat(Icons.local_fire_department_outlined, '$streak'),
              const SizedBox(width: 8),
              _MiniStat(Icons.bolt_outlined, '$xp'),
            ]),
            const SizedBox(height: 24),
            _ProgressCard(done: completedLessons, total: totalLessons),
            const SizedBox(height: 24),
            const _Title('Continue growing'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PillarDetailScreen(pillar: currentPillar))),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [EvermoreTheme.primary, EvermoreTheme.primaryDark]), borderRadius: BorderRadius.circular(23)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('PILLAR ${currentPillar.id.toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 9),
                  Text(currentPillar.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 7),
                  Text(currentPillar.description, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.45)),
                  const SizedBox(height: 16),
                  Row(children: [
                    const Icon(Icons.menu_book_outlined, color: Colors.white70, size: 15),
                    const SizedBox(width: 5),
                    Text('${currentPillar.lessons.length} lessons', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                  ]),
                ]),
              ),
            ),
            const SizedBox(height: 24),
            const _Title('Next lesson'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonDetailScreen(lesson: nextLesson))),
              child: _RowCard(icon: Icons.play_arrow_rounded, title: nextLesson.title, subtitle: nextLesson.duration),
            ),
            const SizedBox(height: 24),
            const _Title("Today's challenge"),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChallengesScreen())),
              child: _RowCard(icon: Icons.track_changes_outlined, title: growthChallenges.first.title, subtitle: growthChallenges.first.description),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunityScreen())),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: EvermoreTheme.primary.withValues(alpha: .06), borderRadius: BorderRadius.circular(20), border: Border.all(color: EvermoreTheme.primary.withValues(alpha: .12))),
                child: const Row(children: [
                  Icon(Icons.send_rounded, color: EvermoreTheme.primary),
                  SizedBox(width: 13),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Join the Evermore community', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    SizedBox(height: 4),
                    Text('Discussions, accountability, announcements and live sessions.', style: TextStyle(fontSize: 11, color: EvermoreTheme.muted)),
                  ])),
                  Icon(Icons.arrow_forward_rounded, size: 18, color: EvermoreTheme.primary),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;
  const _Title(this.text);
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800));
}

class _MiniStat extends StatelessWidget {
  final IconData icon; final String value;
  const _MiniStat(this.icon, this.value);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), border: Border.all(color: EvermoreTheme.border)),
    child: Row(children: [Icon(icon, size: 15, color: EvermoreTheme.primary), const SizedBox(width: 4), Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800))]),
  );
}

class _ProgressCard extends StatelessWidget {
  final int done, total;
  const _ProgressCard({required this.done, required this.total});
  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : (done / total).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(21), border: Border.all(color: EvermoreTheme.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Expanded(child: Text('Program progress', style: TextStyle(fontWeight: FontWeight.w800))), Text('${(progress * 100).round()}%', style: const TextStyle(color: EvermoreTheme.primary, fontWeight: FontWeight.w800))]),
        const SizedBox(height: 12),
        ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: progress, minHeight: 8, color: EvermoreTheme.primary, backgroundColor: EvermoreTheme.background)),
        const SizedBox(height: 9),
        Text('$done of $total lessons completed', style: const TextStyle(fontSize: 10, color: EvermoreTheme.muted)),
      ]),
    );
  }
}

class _RowCard extends StatelessWidget {
  final IconData icon; final String title; final String subtitle;
  const _RowCard({required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: EvermoreTheme.border)),
    child: Row(children: [
      Container(width: 46, height: 46, decoration: BoxDecoration(color: EvermoreTheme.primary.withValues(alpha: .08), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: EvermoreTheme.primary)),
      const SizedBox(width: 13),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
        const SizedBox(height: 4),
        Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: EvermoreTheme.muted)),
      ])),
      const Icon(Icons.chevron_right_rounded, color: EvermoreTheme.muted),
    ]),
  );
}
