import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final service = ProgressService();
    final lessons = await service.completedLessons();
    final reflection = await service.getReflection(widget.lesson.id);
    if (mounted) {
      setState(() {
        completed = lessons.contains(widget.lesson.id);
        reflectionController.text = reflection;
      });
    }
  }

  Future<void> complete() async {
    final service = ProgressService();
    await service.saveReflection(widget.lesson.id, reflectionController.text.trim());
    await service.completeLesson(widget.lesson.id);
    if (mounted) {
      setState(() => completed = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('+25 XP earned')));
    }
  }

  @override
  void dispose() {
    reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    return Scaffold(
      appBar: AppBar(title: const Text('Lesson', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 35),
        children: [
          Text(lesson.title, style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w800, height: 1.1)),
          const SizedBox(height: 8),
          Text(lesson.duration, style: const TextStyle(color: EvermoreTheme.primary, fontWeight: FontWeight.w700, fontSize: 11)),
          const SizedBox(height: 25),
          const Text('Why this matters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(lesson.whyItMatters, style: const TextStyle(height: 1.55, color: EvermoreTheme.muted)),
          const SizedBox(height: 25),
          const Text('Core concepts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          ...lesson.concepts.map((text) => _Bullet(text: text)),
          const SizedBox(height: 25),
          ...lesson.sections.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 17),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('01.${entry.key + 1}', style: const TextStyle(color: EvermoreTheme.primary, fontSize: 10, fontWeight: FontWeight.w800)),
              const SizedBox(height: 5),
              Text(entry.value, style: const TextStyle(fontSize: 14, height: 1.55)),
            ]),
          )),
          const SizedBox(height: 10),
          const Text('Your action', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          ...lesson.actions.map((text) => _Bullet(text: text)),
          const SizedBox(height: 25),
          const Text('Reflection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text('What did this lesson make you realise, and what will you do differently?', style: TextStyle(color: EvermoreTheme.muted, height: 1.45)),
          const SizedBox(height: 10),
          TextField(controller: reflectionController, maxLines: 5, decoration: const InputDecoration(hintText: 'Write your reflection...')),
          const SizedBox(height: 25),
          const Text('Key takeaways', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          ...lesson.takeaways.map((text) => _Bullet(text: text)),
          const SizedBox(height: 25),
          NeoPillButton(
            label: completed ? 'Lesson completed' : 'Complete lesson +25 XP',
            onPressed: completed ? null : complete,
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.check_rounded, size: 17, color: EvermoreTheme.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.45))),
      ]),
    );
  }
}
