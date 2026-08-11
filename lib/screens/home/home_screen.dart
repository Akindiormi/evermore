import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
import '../../core/widgets/evermore_background.dart';
import '../../core/widgets/evermore_mark.dart';
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

  @override
  Widget build(BuildContext context) {
    final totalLessons = growthPillars.expand((p) => p.lessons).length;
    final currentPillar = growthPillars[(completedLessons ~/ 5).clamp(0, growthPillars.length - 1)];
    final nextLesson = currentPillar.lessons[completedLessons % currentPillar.lessons.length];
    final progress = totalLessons == 0 ? 0.0 : (completedLessons / totalLessons).clamp(0.0, 1.0);

    return EvermoreBackground(
      child: SafeArea(
        child: RefreshIndicator(
          color: EvermoreTheme.primary,
          onRefresh: _load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 125),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('EVERMORE', style: TextStyle(fontSize: 10, letterSpacing: 1.8, fontWeight: FontWeight.w900, color: EvermoreTheme.primary)),
                        SizedBox(height: 5),
                        Text('Keep becoming.', style: TextStyle(fontSize: 28, height: 1.05, fontWeight: FontWeight.w800, letterSpacing: -.8)),
                      ],
                    ),
                  ),
                  _MiniStat(Icons.local_fire_department_rounded, '$streak', 'streak'),
                  const SizedBox(width: 8),
                  _MiniStat(Icons.bolt_rounded, '$xp', 'XP'),
                ],
              ),
              const SizedBox(height: 22),
              _ProgressCard(done: completedLessons, total: totalLessons, progress: progress),
              const SizedBox(height: 28),
              const _SectionTitle('Continue growing', eyebrow: 'YOUR NEXT STEP'),
              const SizedBox(height: 12),
              _AnimatedHeroCard(
                pillar: currentPillar,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PillarDetailScreen(pillar: currentPillar))),
              ),
              const SizedBox(height: 27),
              const _SectionTitle('Next lesson', eyebrow: 'KEEP THE MOMENTUM'),
              const SizedBox(height: 12),
              _ActionCard(
                icon: Icons.play_arrow_rounded,
                title: nextLesson.title,
                subtitle: nextLesson.duration,
                trailing: 'Start',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonDetailScreen(lesson: nextLesson))),
              ),
              const SizedBox(height: 27),
              const _SectionTitle("Today's challenge", eyebrow: 'PUT IT INTO ACTION'),
              const SizedBox(height: 12),
              _ActionCard(
                icon: Icons.track_changes_rounded,
                title: growthChallenges.first.title,
                subtitle: growthChallenges.first.description,
                trailing: 'Open',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChallengesScreen())),
              ),
              const SizedBox(height: 27),
              _CommunityBanner(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunityScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final String eyebrow;
  const _SectionTitle(this.text, {required this.eyebrow});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(eyebrow, style: const TextStyle(fontSize: 9, letterSpacing: 1.2, fontWeight: FontWeight.w900, color: EvermoreTheme.primary)),
      const SizedBox(height: 4),
      Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -.2)),
    ],
  );
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _MiniStat(this.icon, this.value, this.label);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: EvermoreTheme.glassCard(radius: 15, color: Colors.white.withValues(alpha: .72)),
    child: Row(children: [
      Icon(icon, size: 15, color: EvermoreTheme.primary),
      const SizedBox(width: 4),
      Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
      const SizedBox(width: 3),
      Text(label, style: const TextStyle(fontSize: 9, color: EvermoreTheme.muted, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _ProgressCard extends StatelessWidget {
  final int done, total;
  final double progress;
  const _ProgressCard({required this.done, required this.total, required this.progress});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(19),
    decoration: EvermoreTheme.glassCard(radius: 24, color: Colors.white.withValues(alpha: .72)),
    child: Row(children: [
      SizedBox(
        width: 68,
        height: 68,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: progress),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (_, value, __) => Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(value: 1, strokeWidth: 7, color: EvermoreTheme.primary.withValues(alpha: .08)),
              CircularProgressIndicator(value: value, strokeWidth: 7, strokeCap: StrokeCap.round, color: EvermoreTheme.primary),
              Text('${(value * 100).round()}%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Program progress', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
        const SizedBox(height: 5),
        Text('$done of $total lessons completed', style: const TextStyle(fontSize: 11, color: EvermoreTheme.muted)),
        const SizedBox(height: 11),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 900),
            builder: (_, value, __) => LinearProgressIndicator(value: value, minHeight: 6, color: EvermoreTheme.primary, backgroundColor: EvermoreTheme.primary.withValues(alpha: .08)),
          ),
        ),
      ])),
    ]),
  );
}

class _AnimatedHeroCard extends StatefulWidget {
  final GrowthPillar pillar;
  final VoidCallback onTap;
  const _AnimatedHeroCard({required this.pillar, required this.onTap});

  @override
  State<_AnimatedHeroCard> createState() => _AnimatedHeroCardState();
}

class _AnimatedHeroCardState extends State<_AnimatedHeroCard> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);

  @override
  void dispose() { controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: widget.onTap,
    child: AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1 + controller.value * .25, -1),
            end: Alignment(1, 1 - controller.value * .2),
            colors: const [EvermoreTheme.primary, EvermoreTheme.primaryMid, EvermoreTheme.violet],
          ),
          borderRadius: BorderRadius.circular(29),
          boxShadow: [BoxShadow(color: EvermoreTheme.primary.withValues(alpha: .22), blurRadius: 32, offset: const Offset(0, 16), spreadRadius: -9)],
        ),
        child: Stack(children: [
          const Positioned(right: -8, top: -15, child: Opacity(opacity: .12, child: EvermoreMark(size: 105, color: Colors.white))),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('PILLAR ${widget.pillar.id.toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 1.4, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            Text(widget.pillar.title, style: const TextStyle(color: Colors.white, fontSize: 24, height: 1.05, fontWeight: FontWeight.w800, letterSpacing: -.5)),
            const SizedBox(height: 8),
            Text(widget.pillar.description, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.45)),
            const SizedBox(height: 18),
            Row(children: [
              const Icon(Icons.menu_book_rounded, color: Colors.white70, size: 15),
              const SizedBox(width: 5),
              Text('${widget.pillar.lessons.length} lessons', style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
              const Spacer(),
              Container(width: 42, height: 42, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .16), shape: BoxShape.circle, border: Border.all(color: Colors.white24)), child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20)),
            ]),
          ]),
        ]),
      ),
    ),
  );
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle, trailing;
  final VoidCallback onTap;
  const _ActionCard({required this.icon, required this.title, required this.subtitle, required this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(15),
        decoration: EvermoreTheme.glassCard(radius: 22, color: Colors.white.withValues(alpha: .72)),
        child: Row(children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(gradient: EvermoreTheme.softGradient, borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: EvermoreTheme.primary)),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(height: 4),
            Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, height: 1.35, color: EvermoreTheme.muted)),
          ])),
          const SizedBox(width: 8),
          Text(trailing, style: const TextStyle(color: EvermoreTheme.primary, fontSize: 11, fontWeight: FontWeight.w800)),
          const SizedBox(width: 3),
          const Icon(Icons.chevron_right_rounded, size: 19, color: EvermoreTheme.primary),
        ]),
      ),
    ),
  );
}

class _CommunityBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _CommunityBanner({required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: EvermoreTheme.primary.withValues(alpha: .065), borderRadius: BorderRadius.circular(22), border: Border.all(color: EvermoreTheme.primary.withValues(alpha: .12))),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: EvermoreTheme.primary, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.groups_rounded, color: Colors.white)),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Grow with people', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            SizedBox(height: 4),
            Text('Open the Evermore community and stay accountable.', style: TextStyle(fontSize: 10.5, color: EvermoreTheme.muted, height: 1.35)),
          ])),
          const Icon(Icons.arrow_forward_rounded, size: 18, color: EvermoreTheme.primary),
        ]),
      ),
    ),
  );
}
