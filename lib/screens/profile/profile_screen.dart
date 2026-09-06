import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
import '../../core/widgets/evermore_background.dart';
import '../../core/widgets/evermore_mark.dart';
import '../../data/growth_data.dart';
import '../../services/progress_service.dart';
import '../../widgets/avatar_picker.dart';
import '../challenges/challenges_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int xp = 0;
  int streak = 0;
  int lessons = 0;
  int challenges = 0;
  List<String> goals = [];
  String name = '';
  String? photoPath;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final service = ProgressService();
    final completedLessons = await service.completedLessons();
    final completedChallenges = await service.completedChallenges();
    final loadedGoals = await service.getGoals();
    final loadedXp = await service.getXp();
    final loadedStreak = await service.getStreak();
    final loadedName = await service.getProfileName();
    final loadedPhoto = await service.getProfilePhotoPath();

    if (!mounted) return;

    setState(() {
      xp = loadedXp;
      streak = loadedStreak;
      lessons = completedLessons.length;
      challenges = completedChallenges.length;
      goals = loadedGoals;
      name = loadedName;
      photoPath = loadedPhoto;
    });
  }

  Future<void> _openEditProfile() async {
    final service = ProgressService();
    final controller = TextEditingController(text: name);
    String? draftPhoto = photoPath;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white.withValues(alpha: .96),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                10,
                20,
                20 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: EvermoreTheme.divider,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const Text(
                    'Edit profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: AvatarPicker(
                      photoPath: draftPhoto,
                      name: controller.text,
                      size: 96,
                      onChanged: (path) => setSheetState(() => draftPhoto = path),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your name',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (_) => setSheetState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'e.g. Akin Diormi',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: controller.text.trim().isEmpty
                          ? null
                          : () async {
                              await service.saveProfileName(controller.text.trim());
                              if (draftPhoto != null) {
                                await service.saveProfilePhotoPath(draftPhoto!);
                              } else {
                                await service.clearProfilePhoto();
                              }
                              if (sheetContext.mounted) {
                                Navigator.pop(sheetContext);
                              }
                            },
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text(
                        'Save changes',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: EvermoreTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    controller.dispose();
    await _load();
  }

  Future<void> _savePhoto(String? path) async {
    if (path != null) {
      await ProgressService().saveProfilePhotoPath(path);
    } else {
      await ProgressService().clearProfilePhoto();
    }
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final displayName = name.isEmpty ? 'Evermore member' : name;
    final totalLessons = growthPillars.fold<int>(
      0,
      (sum, pillar) => sum + pillar.lessons.length,
    );
    final overall = totalLessons == 0
        ? 0.0
        : (lessons / totalLessons).clamp(0.0, 1.0).toDouble();

    return EvermoreBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 125),
          children: [
            const Text(
              'My growth',
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800, letterSpacing: -.8),
            ),
            const SizedBox(height: 7),
            const Text(
              'Your progress through the Evermore program.',
              style: TextStyle(color: EvermoreTheme.muted, fontSize: 13.5),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: EvermoreTheme.glassCard(
                radius: 29,
                color: Colors.white.withValues(alpha: .75),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 92,
                        height: 92,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: EvermoreTheme.logoGradient,
                          boxShadow: EvermoreTheme.floatingShadow,
                        ),
                        child: AvatarPicker(
                          photoPath: photoPath,
                          name: name,
                          size: 86,
                          onChanged: _savePhoto,
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: EvermoreTheme.primary.withValues(alpha: .15),
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 14,
                          color: EvermoreTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    displayName,
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Keep learning. Keep applying. Keep becoming.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10.5, color: EvermoreTheme.muted),
                  ),
                  const SizedBox(height: 15),
                  OutlinedButton.icon(
                    onPressed: _openEditProfile,
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text(
                      'Edit profile',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: EvermoreTheme.primary,
                      side: BorderSide(
                        color: EvermoreTheme.primary.withValues(alpha: .45),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _StatCard(Icons.bolt_rounded, '$xp', 'XP')),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    Icons.local_fire_department_rounded,
                    '$streak',
                    'Day streak',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(Icons.menu_book_rounded, '$lessons', 'Lessons'),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: EvermoreTheme.glassCard(
                radius: 24,
                color: Colors.white.withValues(alpha: .7),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 62,
                    height: 62,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: overall),
                      duration: const Duration(milliseconds: 900),
                      builder: (_, value, __) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: 1,
                              strokeWidth: 6,
                              color: EvermoreTheme.primary.withValues(alpha: .08),
                            ),
                            CircularProgressIndicator(
                              value: value,
                              strokeWidth: 6,
                              strokeCap: StrokeCap.round,
                              color: EvermoreTheme.primary,
                            ),
                            Text(
                              '${(value * 100).round()}%',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Program completion',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Every lesson moves you forward. Keep your streak alive.',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: EvermoreTheme.muted,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'My focus areas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                if (goals.isNotEmpty)
                  Text(
                    '${goals.length}',
                    style: const TextStyle(
                      color: EvermoreTheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 11),
            if (goals.isEmpty)
              const Text(
                'Your focus areas will appear here after onboarding.',
                style: TextStyle(fontSize: 11, color: EvermoreTheme.muted),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: goals
                    .map(
                      (goal) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: EvermoreTheme.primary.withValues(alpha: .07),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: EvermoreTheme.primary.withValues(alpha: .1),
                          ),
                        ),
                        child: Text(
                          goal,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: EvermoreTheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 22),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(23),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChallengesScreen(),
                    ),
                  );
                },
                child: Ink(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: EvermoreTheme.heroGradient,
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KEEP BUILDING',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 9,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Put your learning into action.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: EvermoreTheme.softGradient,
                borderRadius: BorderRadius.circular(23),
              ),
              child: const Stack(
                children: [
                  Positioned(
                    right: -8,
                    bottom: -10,
                    child: Opacity(
                      opacity: .12,
                      child: EvermoreMark(size: 80),
                    ),
                  ),
                  Text(
                    'Growth is not one big transformation. It is the result of learning, applying, reflecting and repeating.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.55,
                      color: EvermoreTheme.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard(this.icon, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: EvermoreTheme.glassCard(
        radius: 18,
        color: Colors.white.withValues(alpha: .72),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              gradient: EvermoreTheme.softGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 15, color: EvermoreTheme.primary),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: EvermoreTheme.muted),
          ),
        ],
      ),
    );
  }
}
