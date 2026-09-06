class CourseLesson {
  final String id;
  final String title;
  final String summary;
  final String content;
  const CourseLesson({required this.id, required this.title, required this.summary, required this.content});
}

class Course {
  final String id;
  final String title;
  final String category;
  final String description;
  final List<String> benefits;
  final List<CourseLesson> lessons;
  const Course({required this.id, required this.title, required this.category, required this.description, required this.benefits, required this.lessons});
}
