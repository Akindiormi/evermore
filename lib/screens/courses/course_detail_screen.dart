import 'package:flutter/material.dart';

import '../../core/theme/evermore_theme.dart';
import '../../core/widgets/evermore_background.dart';
import '../../models/course.dart';
import '../../services/progress_service.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  Set<String> completed = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final c = await ProgressService().completedLessons();
    if (mounted) setState(() => completed = c);
  }

  @override
  Widget build(BuildContext context) {
    final done = widget.course.lessons
        .where((lesson) => completed.contains(lesson.id))
        .length;
    final progress = done / widget.course.lessons.length;

    return Scaffold(
      appBar: AppBar(title: Text(widget.course.title)),
      body: EvermoreBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 35),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: EvermoreTheme.heroGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: EvermoreTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.course.category.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 9,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.course.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.5,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    widget.course.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.course.lessons.length} lessons',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${(progress * 100).round()}% complete',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'What you will learn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            ...widget.course.benefits.map(
              (benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: EvermoreTheme.primary,
                      size: 17,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        benefit,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Modules & lessons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            ...widget.course.lessons.map((lesson) {
              final isDone = completed.contains(lesson.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseLessonScreen(
                            course: widget.course,
                            lesson: lesson,
                          ),
                        ),
                      );
                      await _load();
                    },
                    child: Ink(
                      padding: const EdgeInsets.all(15),
                      decoration: EvermoreTheme.glassCard(
                        radius: 20,
                        color: Colors.white.withValues(alpha: .74),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: EvermoreTheme.primary.withValues(alpha: .08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isDone
                                  ? Icons.check_rounded
                                  : Icons.play_arrow_rounded,
                              color: EvermoreTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lesson.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lesson.summary,
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: EvermoreTheme.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: EvermoreTheme.primary,
                          ),
                        ],
                      ),
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

class CourseLessonScreen extends StatefulWidget {
  final Course course;
  final CourseLesson lesson;

  const CourseLessonScreen({
    super.key,
    required this.course,
    required this.lesson,
  });

  @override
  State<CourseLessonScreen> createState() => _CourseLessonScreenState();
}

class _CourseLessonScreenState extends State<CourseLessonScreen> {
  bool done = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final lessons = await ProgressService().completedLessons();
    if (mounted) {
      setState(() => done = lessons.contains(widget.lesson.id));
    }
  }

  Future<void> _complete() async {
    await ProgressService().completeLesson(widget.lesson.id);
    if (mounted) setState(() => done = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.course.title)),
      body: EvermoreBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 35),
          children: [
            Text(
              widget.course.category.toUpperCase(),
              style: const TextStyle(
                fontSize: 9,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w900,
                color: EvermoreTheme.primary,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              widget.lesson.title,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w800,
                letterSpacing: -.6,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: EvermoreTheme.glassCard(
                radius: 22,
                color: Colors.white.withValues(alpha: .75),
              ),
              child: Text(
                widget.lesson.content,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.65,
                  color: EvermoreTheme.text,
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: done ? null : _complete,
                icon: Icon(
                  done
                      ? Icons.check_rounded
                      : Icons.check_circle_outline_rounded,
                ),
                label: Text(
                  done ? 'Lesson completed' : 'Mark lesson complete',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: EvermoreTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
