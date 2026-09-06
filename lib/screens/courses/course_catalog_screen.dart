import 'package:flutter/material.dart';

import '../../core/theme/evermore_theme.dart';
import '../../core/widgets/evermore_background.dart';
import '../../data/course_catalog.dart';
import '../../models/course.dart';
import '../../services/progress_service.dart';
import 'course_detail_screen.dart';

class CourseCatalogScreen extends StatefulWidget {
  const CourseCatalogScreen({super.key});

  @override
  State<CourseCatalogScreen> createState() => _CourseCatalogScreenState();
}

class _CourseCatalogScreenState extends State<CourseCatalogScreen> {
  String category = 'All';
  String query = '';
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
    final categories = [
      'All',
      ...courseCatalog.map((course) => course.category).toSet(),
    ];
    final filtered = courseCatalog.where((course) {
      final categoryMatches =
          category == 'All' || course.category == category;
      final queryMatches = query.isEmpty ||
          course.title.toLowerCase().contains(query.toLowerCase());
      return categoryMatches && queryMatches;
    }).toList();

    return Scaffold(
      body: EvermoreBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _load,
            color: EvermoreTheme.primary,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 125),
              children: [
                const Text(
                  'Learn',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.8,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '${courseCatalog.length} practical courses across five growth categories.',
                  style: const TextStyle(
                    color: EvermoreTheme.muted,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 17),
                TextField(
                  onChanged: (value) => setState(() => query = value),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded),
                    hintText: 'Search courses',
                  ),
                ),
                const SizedBox(height: 13),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, index) {
                      final item = categories[index];
                      final selected = item == category;
                      return GestureDetector(
                        onTap: () => setState(() => category = item),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? EvermoreTheme.primary
                                : Colors.white.withValues(alpha: .72),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: selected
                                  ? EvermoreTheme.primary
                                  : EvermoreTheme.divider,
                            ),
                          ),
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: selected
                                  ? Colors.white
                                  : EvermoreTheme.muted,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                ...filtered.map(
                  (course) => _CourseCard(
                    course: course,
                    completed: completed,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseDetailScreen(course: course),
                        ),
                      );
                      await _load();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  final Set<String> completed;
  final VoidCallback onTap;

  const _CourseCard({
    required this.course,
    required this.completed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final done = course.lessons
        .where((lesson) => completed.contains(lesson.id))
        .length;
    final progress = done / course.lessons.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: EvermoreTheme.glassCard(
              radius: 22,
              color: Colors.white.withValues(alpha: .74),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: progress > 0
                        ? EvermoreTheme.logoGradient
                        : EvermoreTheme.softGradient,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    _icon(course.category),
                    color: progress > 0
                        ? Colors.white
                        : EvermoreTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 8.5,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w900,
                          color: EvermoreTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: EvermoreTheme.muted,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 4,
                              color: EvermoreTheme.primary,
                              backgroundColor:
                                  EvermoreTheme.primary.withValues(alpha: .08),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$done/${course.lessons.length}',
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: EvermoreTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
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
  }

  static IconData _icon(String category) {
    return switch (category) {
      'Digital Skills' => Icons.laptop_mac_rounded,
      'Financial Literacy' => Icons.account_balance_wallet_outlined,
      'Career Growth' => Icons.work_outline_rounded,
      'Communication' => Icons.forum_outlined,
      _ => Icons.business_center_outlined,
    };
  }
}
