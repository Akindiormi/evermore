class GrowthLesson {
  final String id;
  final String title;
  final String duration;
  final String whyItMatters;
  final List<String> concepts;
  final List<String> sections;
  final List<String> actions;
  final List<String> takeaways;
  final List<String> quizQuestions;

  const GrowthLesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.whyItMatters,
    required this.concepts,
    required this.sections,
    required this.actions,
    required this.takeaways,
    required this.quizQuestions,
  });
}

class GrowthPillar {
  final int id;
  final String title;
  final String description;
  final List<GrowthLesson> lessons;

  const GrowthPillar({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
  });
}
