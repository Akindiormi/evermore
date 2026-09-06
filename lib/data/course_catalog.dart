import '../models/course.dart';

const _digital = <String>[
  'Web Development','Mobile App Development','UI/UX Design','Graphic Design','Video Editing','Content Creation','Digital Marketing','Social Media Management','SEO','Copywriting','Data Analysis','AI Tools','No-Code Tools','WordPress','E-commerce',
];
const _finance = <String>[
  'Personal Finance','Budgeting','Saving','Investing Fundamentals','Understanding Credit','Financial Planning','Money Management','Business Finance','Risk Management','Understanding Assets & Liabilities',
];
const _career = <String>[
  'CV/Resume Writing','Interview Skills','LinkedIn','Career Planning','Remote Work','Freelancing','Building a Portfolio','Personal Branding','Workplace Skills','Negotiation',
];
const _communication = <String>[
  'Public Speaking','Business Communication','Professional Writing','Presentation Skills','Active Listening','Storytelling','Networking','Confidence in Communication',
];
const _business = <String>[
  'Entrepreneurship Fundamentals','Business Ideas','Market Research','Customer Acquisition','Sales','Branding','Business Strategy','E-commerce for Business','Client Management','Business Operations','Pricing Strategy','Customer Retention',
];

String _description(String title, String category) => switch (category) {
  'Digital Skills' => 'Build practical $title skills through guided concepts, examples and hands-on exercises you can apply to real projects.',
  'Financial Literacy' => 'Learn the fundamentals of $title and turn them into practical habits for clearer, more responsible financial decisions.',
  'Career Growth' => 'Develop practical $title skills that help you present yourself clearly, find opportunities and perform with confidence.',
  'Communication' => 'Strengthen your $title skills with practical frameworks, exercises and real-world communication scenarios.',
  _ => 'Learn practical $title skills for starting, improving or operating a modern business with clearer decisions and repeatable systems.',
};

List<CourseLesson> _lessons(String id, String title, String category) {
  final focus = switch (category) {
    'Digital Skills' => ['Core concepts and tools', 'Build a practical workflow', 'Project and next steps'],
    'Financial Literacy' => ['Core principles', 'Apply the numbers to real life', 'Build a personal action plan'],
    'Career Growth' => ['Foundations that matter', 'Practice with real examples', 'Create your next-step plan'],
    'Communication' => ['Principles and common mistakes', 'Practice a repeatable framework', 'Use it in a real conversation'],
    _ => ['Business foundations', 'Build a practical system', 'Apply it to a real business idea'],
  };
  return List.generate(3, (i) => CourseLesson(
    id: '$id-${i + 1}',
    title: '${i + 1}. ${focus[i]}',
    summary: 'A focused lesson on $title.',
    content: 'This lesson breaks $title into practical steps. Review the key ideas, work through the examples, and finish by writing down one action you can apply immediately. Keep your notes specific and measurable so progress is easy to track.',
  ));
}

List<Course> _build(String category, List<String> titles, String prefix) => [
  for (var i = 0; i < titles.length; i++) Course(
    id: '$prefix-${i + 1}', title: titles[i], category: category,
    description: _description(titles[i], category),
    benefits: const ['Structured modules', 'Practical exercises', 'Progress tracking'],
    lessons: _lessons('$prefix-${i + 1}', titles[i], category),
  ),
];

final List<Course> courseCatalog = [
  ..._build('Digital Skills', _digital, 'digital'),
  ..._build('Financial Literacy', _finance, 'finance'),
  ..._build('Career Growth', _career, 'career'),
  ..._build('Communication', _communication, 'communication'),
  ..._build('Business & Entrepreneurship', _business, 'business'),
];
