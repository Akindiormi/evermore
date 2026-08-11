import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
import '../../core/widgets/evermore_background.dart';
import '../../data/growth_data.dart';
import '../../services/progress_service.dart';
import '../lesson/lesson_detail_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});
  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  int filter = 0;
  Set<String> completed = {};

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final data = await ProgressService().completedLessons();
    if (mounted) setState(() => completed = data);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = growthPillars.where((pillar) {
      final done = pillar.lessons.where((l) => completed.contains(l.id)).length;
      if (filter == 1) return done > 0 && done < pillar.lessons.length;
      if (filter == 2) return done == pillar.lessons.length;
      return true;
    }).toList();

    return EvermoreBackground(
      child: SafeArea(
        child: RefreshIndicator(
          color: EvermoreTheme.primary,
          onRefresh: _load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 125),
            children: [
              const Text('Learn', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800, letterSpacing: -.8)),
              const SizedBox(height: 7),
              const Text('Ten areas of growth. Fifty practical lessons.', style: TextStyle(color: EvermoreTheme.muted, fontSize: 13.5, height: 1.4)),
              const SizedBox(height: 20),
              Row(children: [
                _Filter(label: 'All', selected: filter == 0, onTap: () => setState(() => filter = 0)),
                const SizedBox(width: 8),
                _Filter(label: 'In progress', selected: filter == 1, onTap: () => setState(() => filter = 1)),
                const SizedBox(width: 8),
                _Filter(label: 'Completed', selected: filter == 2, onTap: () => setState(() => filter = 2)),
              ]),
              const SizedBox(height: 20),
              if (filtered.isEmpty)
                _EmptyState(filter: filter, onReset: () => setState(() => filter = 0))
              else
                ...filtered.asMap().entries.map((entry) => _PillarCard(
                  pillar: entry.value,
                  completed: completed,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PillarDetailScreen(pillar: entry.value))).then((_) => _load()),
                )),
            ],
          ),
        ),
      ),
    );
  }
}

class _Filter extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Filter({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? EvermoreTheme.primary : Colors.white.withValues(alpha: .68),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: selected ? EvermoreTheme.primary : EvermoreTheme.divider),
        boxShadow: selected ? [BoxShadow(color: EvermoreTheme.primary.withValues(alpha: .16), blurRadius: 15, offset: const Offset(0, 7), spreadRadius: -5)] : const [],
      ),
      child: Text(label, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: selected ? Colors.white : EvermoreTheme.muted)),
    ),
  );
}

class _PillarCard extends StatelessWidget {
  final GrowthPillar pillar;
  final Set<String> completed;
  final VoidCallback onTap;
  const _PillarCard({required this.pillar, required this.completed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final done = pillar.lessons.where((l) => completed.contains(l.id)).length;
    final progress = pillar.lessons.isEmpty ? 0.0 : done / pillar.lessons.length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: EvermoreTheme.glassCard(radius: 24, color: Colors.white.withValues(alpha: .72)),
            child: Row(children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(gradient: progress > 0 ? EvermoreTheme.logoGradient : EvermoreTheme.softGradient, borderRadius: BorderRadius.circular(17)),
                child: Center(child: Text('${pillar.id}'.padLeft(2, '0'), style: TextStyle(fontWeight: FontWeight.w900, color: progress > 0 ? Colors.white : EvermoreTheme.primary))),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(pillar.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                const SizedBox(height: 4),
                Text(pillar.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, height: 1.35, color: EvermoreTheme.muted)),
                const SizedBox(height: 9),
                Row(children: [
                  Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: progress, minHeight: 4, color: EvermoreTheme.primary, backgroundColor: EvermoreTheme.primary.withValues(alpha: .08)))),
                  const SizedBox(width: 8),
                  Text('$done/${pillar.lessons.length}', style: const TextStyle(fontSize: 9.5, color: EvermoreTheme.primary, fontWeight: FontWeight.w800)),
                ]),
              ])),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: EvermoreTheme.primary),
            ]),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final int filter;
  final VoidCallback onReset;
  const _EmptyState({required this.filter, required this.onReset});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: EvermoreTheme.glassCard(radius: 24),
    child: Column(children: [
      const Icon(Icons.auto_awesome_rounded, size: 28, color: EvermoreTheme.primary),
      const SizedBox(height: 12),
      Text(filter == 2 ? 'Nothing completed yet' : 'Nothing in progress yet', style: const TextStyle(fontWeight: FontWeight.w800)),
      const SizedBox(height: 5),
      const Text('Start a lesson and your progress will appear here.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: EvermoreTheme.muted)),
      const SizedBox(height: 14),
      TextButton(onPressed: onReset, child: const Text('View all lessons')),
    ]),
  );
}

class PillarDetailScreen extends StatelessWidget {
  final GrowthPillar pillar;
  const PillarDetailScreen({super.key, required this.pillar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pillar.title)),
      body: EvermoreBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 35),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(gradient: EvermoreTheme.heroGradient, borderRadius: BorderRadius.circular(28), boxShadow: EvermoreTheme.cardShadow),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('PILLAR ${pillar.id.toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 1.3, fontWeight: FontWeight.w900)),
                const SizedBox(height: 9),
                Text(pillar.title, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800)),
                const SizedBox(height: 7),
                Text(pillar.description, style: const TextStyle(color: Colors.white70, height: 1.45, fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 22),
            Text('${pillar.lessons.length} practical lessons', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 11),
            ...pillar.lessons.asMap().entries.map((entry) {
              final lesson = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonDetailScreen(lesson: lesson))),
                    child: Ink(
                      padding: const EdgeInsets.all(15),
                      decoration: EvermoreTheme.glassCard(radius: 20, color: Colors.white.withValues(alpha: .74)),
                      child: Row(children: [
                        Container(width: 40, height: 40, decoration: BoxDecoration(color: EvermoreTheme.primary.withValues(alpha: .08), shape: BoxShape.circle), child: Center(child: Text('${entry.key + 1}', style: const TextStyle(color: EvermoreTheme.primary, fontWeight: FontWeight.w900)))),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)), const SizedBox(height: 4), Text(lesson.duration, style: const TextStyle(fontSize: 10, color: EvermoreTheme.muted))])),
                        const Icon(Icons.arrow_forward_rounded, size: 18, color: EvermoreTheme.primary),
                      ]),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
