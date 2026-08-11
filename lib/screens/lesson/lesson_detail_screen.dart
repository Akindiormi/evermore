import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/evermore_theme.dart';
import '../../core/widgets/evermore_background.dart';
import '../../core/widgets/evermore_mark.dart';
import '../../models/lesson.dart';
import '../../services/progress_service.dart';
import '../../widgets/neo_pill_button.dart';

class LessonDetailScreen extends StatefulWidget {
  final GrowthLesson lesson;
  const LessonDetailScreen({super.key, required this.lesson});
  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final reflectionController = TextEditingController();
  bool completed = false;
  bool saving = false;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final service = ProgressService();
    final lessons = await service.completedLessons();
    final reflection = await service.getReflection(widget.lesson.id);
    if (mounted) setState(() { completed = lessons.contains(widget.lesson.id); reflectionController.text = reflection; });
  }

  Future<void> complete() async {
    if (saving) return;
    setState(() => saving = true);
    HapticFeedback.mediumImpact();
    final service = ProgressService();
    await service.saveReflection(widget.lesson.id, reflectionController.text.trim());
    await service.completeLesson(widget.lesson.id);
    if (mounted) {
      setState(() { completed = true; saving = false; });
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('+25 XP earned — lesson completed')));
    }
  }

  @override
  void dispose() { reflectionController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    return Scaffold(
      appBar: AppBar(title: const Text('Lesson')),
      body: EvermoreBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 35),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(gradient: EvermoreTheme.heroGradient, borderRadius: BorderRadius.circular(28), boxShadow: EvermoreTheme.cardShadow),
              child: Stack(children: [
                const Positioned(right: -10, top: -12, child: Opacity(opacity: .12, child: EvermoreMark(size: 95, color: Colors.white))),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(lesson.duration.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 1.1, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  Text(lesson.title, style: const TextStyle(color: Colors.white, fontSize: 27, height: 1.08, fontWeight: FontWeight.w800, letterSpacing: -.6)),
                  const SizedBox(height: 10),
                  Text(lesson.whyItMatters, maxLines: 4, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, height: 1.45, fontSize: 11.5)),
                ]),
              ]),
            ),
            const SizedBox(height: 25),
            _Section('Core concepts', lesson.concepts),
            const SizedBox(height: 18),
            const Text('Lesson', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 11),
            ...lesson.sections.asMap().entries.map((entry) => Container(
              margin: const EdgeInsets.only(bottom: 11),
              padding: const EdgeInsets.all(16),
              decoration: EvermoreTheme.glassCard(radius: 20, color: Colors.white.withValues(alpha: .72)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('0${entry.key + 1}', style: const TextStyle(color: EvermoreTheme.primary, fontSize: 10, fontWeight: FontWeight.w900)),
                const SizedBox(width: 12),
                Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 13, height: 1.55))),
              ]),
            )),
            const SizedBox(height: 10),
            const Text('Your action', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            ...lesson.actions.map((text) => _Bullet(text: text)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: EvermoreTheme.glassCard(radius: 23, color: Colors.white.withValues(alpha: .72)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Reflection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 7),
                const Text('What did this lesson make you realise, and what will you do differently?', style: TextStyle(fontSize: 11, color: EvermoreTheme.muted, height: 1.45)),
                const SizedBox(height: 11),
                TextField(controller: reflectionController, maxLines: 5, textInputAction: TextInputAction.newline, decoration: const InputDecoration(hintText: 'Write your reflection...', alignLabelWithHint: true)),
              ]),
            ),
            const SizedBox(height: 18),
            const Text('Key takeaways', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            ...lesson.takeaways.map((text) => _Bullet(text: text)),
            const SizedBox(height: 10),
            NeoPillButton(
              label: saving ? 'Saving...' : completed ? 'Lesson completed ✓' : 'Complete lesson +25 XP',
              icon: completed ? Icons.check_rounded : Icons.arrow_forward_rounded,
              onPressed: completed || saving ? null : complete,
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<String> items;
  const _Section(this.title, this.items);
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
    const SizedBox(height: 10),
    ...items.map((text) => _Bullet(text: text)),
  ]);
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 9), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 22, height: 22, decoration: BoxDecoration(color: EvermoreTheme.primary.withValues(alpha: .08), shape: BoxShape.circle), child: const Icon(Icons.check_rounded, size: 14, color: EvermoreTheme.primary)), const SizedBox(width: 9), Expanded(child: Text(text, style: const TextStyle(fontSize: 12.5, height: 1.45)))]));
}
