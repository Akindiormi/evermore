import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
import '../../services/progress_service.dart';
import '../../widgets/avatar_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int xp = 0, streak = 0, lessons = 0, challenges = 0;
  List<String> goals = [];
  String name = '';
  String? photoPath;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final service = ProgressService();
    final l = await service.completedLessons();
    final c = await service.completedChallenges();
    final g = await service.getGoals();
    final loadedXp = await service.getXp();
    final loadedStreak = await service.getStreak();
    final loadedName = await service.getProfileName();
    final loadedPhoto = await service.getProfilePhotoPath();
    if (mounted) {
      setState(() {
        xp = loadedXp;
        streak = loadedStreak;
        lessons = l.length;
        challenges = c.length;
        goals = g;
        name = loadedName;
        photoPath = loadedPhoto;
      });
    }
  }

  Future<void> _openEditProfile() async {
    final service = ProgressService();
    final controller = TextEditingController(text: name);
    String? draftPhoto = photoPath;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20, right: 20, top: 20,
                bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40, height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: EvermoreTheme.border, borderRadius: BorderRadius.circular(2)),
                  ),
                  const Text('Edit profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 20),
                  Center(
                    child: AvatarPicker(
                      photoPath: draftPhoto,
                      name: controller.text,
                      size: 96,
                      onChanged: (path) => setSheetState(() => draftPhoto = path),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Your name', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (_) => setSheetState(() {}),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    decoration: const InputDecoration(
                      hintText: 'e.g. Akin Diormi',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: controller.text.trim().isEmpty ? null : () async {
                        await service.saveProfileName(controller.text.trim());
                        if (draftPhoto != null) {
                          await service.saveProfilePhotoPath(draftPhoto!);
                        } else {
                          await service.clearProfilePhoto();
                        }
                        if (context.mounted) Navigator.pop(sheetContext);
                      },
                      style: FilledButton.styleFrom(backgroundColor: EvermoreTheme.primary, padding: const EdgeInsets.symmetric(vertical: 15)),
                      child: const Text('Save changes', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final displayName = name.isEmpty ? 'Evermore member' : name;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('My growth', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 7),
                    const Text('Your progress through the Evermore program.', style: TextStyle(color: EvermoreTheme.muted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: EvermoreTheme.premiumCard(radius: 26),
            child: Column(
              children: [
                AvatarPicker(
                  photoPath: photoPath,
                  name: name,
                  size: 80,
                  onChanged: (path) async {
                    final service = ProgressService();
                    if (path != null) {
                      await service.saveProfilePhotoPath(path);
                    } else {
                      await service.clearProfilePhoto();
                    }
                    _load();
                  },
                ),
                const SizedBox(height: 15),
                Text(displayName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 5),
                const Text('Keep learning. Keep applying. Keep becoming.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: EvermoreTheme.muted)),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _openEditProfile,
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit profile', style: TextStyle(fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: EvermoreTheme.primary,
                    side: const BorderSide(color: EvermoreTheme.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _StatCard(Icons.bolt_outlined, '$xp', 'XP')),
            const SizedBox(width: 10),
            Expanded(child: _StatCard(Icons.local_fire_department_outlined, '$streak', 'Day streak')),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _StatCard(Icons.menu_book_outlined, '$lessons', 'Lessons')),
            const SizedBox(width: 10),
            Expanded(child: _StatCard(Icons.track_changes_outlined, '$challenges', 'Challenges')),
          ]),
          const SizedBox(height: 25),
          const Text('My focus areas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: goals.map((g) => Chip(
              label: Text(g, style: const TextStyle(fontWeight: FontWeight.w600)),
              backgroundColor: EvermoreTheme.primary.withValues(alpha: .07),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            )).toList(),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: EvermoreTheme.heroGradient,
              borderRadius: BorderRadius.circular(22),
              boxShadow: EvermoreTheme.cardShadow,
            ),
            child: const Text(
              'Growth is not one big transformation. It is the result of learning, applying, reflecting and repeating.',
              style: TextStyle(fontSize: 13, height: 1.55, color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
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
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: EvermoreTheme.premiumCard(radius: 18),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: EvermoreTheme.primary.withValues(alpha: .08), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 16, color: EvermoreTheme.primary),
      ),
      const SizedBox(height: 12),
      Text(value, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 10, color: EvermoreTheme.muted)),
    ]),
  );
}
