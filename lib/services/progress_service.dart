import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const _completedLessonsKey = 'completed_lessons';
  static const _onboardingKey = 'onboarding_complete';
  static const _selectedGoalsKey = 'selected_goals';
  static const _xpKey = 'xp';
  static const _streakKey = 'streak';
  static const _lastActiveKey = 'last_active';
  static const _completedChallengesKey = 'completed_challenges';
  static const _reflectionsKey = 'reflections';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<bool> hasCompletedOnboarding() async {
    final prefs = await _prefs;
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> completeOnboarding() async {
    final prefs = await _prefs;
    await prefs.setBool(_onboardingKey, true);
    await updateActivity();
  }

  Future<void> saveGoals(List<String> goals) async {
    final prefs = await _prefs;
    await prefs.setStringList(_selectedGoalsKey, goals);
  }

  Future<List<String>> getGoals() async {
    final prefs = await _prefs;
    return prefs.getStringList(_selectedGoalsKey) ?? [];
  }

  Future<Set<String>> completedLessons() async {
    final prefs = await _prefs;
    return (prefs.getStringList(_completedLessonsKey) ?? []).toSet();
  }

  Future<Set<String>> completedChallenges() async {
    final prefs = await _prefs;
    return (prefs.getStringList(_completedChallengesKey) ?? []).toSet();
  }

  Future<int> getXp() async {
    final prefs = await _prefs;
    return prefs.getInt(_xpKey) ?? 0;
  }

  Future<int> getStreak() async {
    final prefs = await _prefs;
    return prefs.getInt(_streakKey) ?? 0;
  }

  Future<void> completeLesson(String id) async {
    final prefs = await _prefs;
    final lessons = await completedLessons();
    if (lessons.add(id)) {
      await prefs.setStringList(_completedLessonsKey, lessons.toList());
      await addXp(25);
      await updateActivity();
    }
  }

  Future<void> completeChallenge(String id, {int xp = 50}) async {
    final prefs = await _prefs;
    final challenges = await completedChallenges();
    if (challenges.add(id)) {
      await prefs.setStringList(_completedChallengesKey, challenges.toList());
      await addXp(xp);
      await updateActivity();
    }
  }

  Future<void> saveReflection(String lessonId, String text) async {
    final prefs = await _prefs;
    final data = prefs.getStringList(_reflectionsKey) ?? [];
    final filtered = data.where((e) => !e.startsWith('$lessonId::')).toList();
    filtered.add('$lessonId::$text');
    await prefs.setStringList(_reflectionsKey, filtered);
  }

  Future<String> getReflection(String lessonId) async {
    final prefs = await _prefs;
    final data = prefs.getStringList(_reflectionsKey) ?? [];
    for (final item in data) {
      if (item.startsWith('$lessonId::')) return item.substring(lessonId.length + 2);
    }
    return '';
  }

  Future<void> addXp(int amount) async {
    final prefs = await _prefs;
    await prefs.setInt(_xpKey, (prefs.getInt(_xpKey) ?? 0) + amount);
  }

  Future<void> updateActivity() async {
    final prefs = await _prefs;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final raw = prefs.getString(_lastActiveKey);

    if (raw == null) {
      await prefs.setInt(_streakKey, 1);
    } else {
      final previous = DateTime.tryParse(raw);
      if (previous != null) {
        final previousDay = DateTime(previous.year, previous.month, previous.day);
        final difference = today.difference(previousDay).inDays;
        if (difference == 1) {
          await prefs.setInt(_streakKey, (prefs.getInt(_streakKey) ?? 0) + 1);
        } else if (difference > 1) {
          await prefs.setInt(_streakKey, 1);
        }
      }
    }
    await prefs.setString(_lastActiveKey, today.toIso8601String());
  }
}
