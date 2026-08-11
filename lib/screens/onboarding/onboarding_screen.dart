import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
import '../../services/progress_service.dart';
import '../../widgets/avatar_picker.dart';
import '../../widgets/neo_pill_button.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final selected = <String>{};
  final nameController = TextEditingController();
  String? photoPath;
  int page = 0;

  final goals = const [
    'Personal development', 'Mindset', 'Productivity', 'Communication',
    'Financial literacy', 'Career growth', 'Digital skills', 'Leadership',
    'Goal setting', 'Discipline',
  ];

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void finish() async {
    final service = ProgressService();
    await service.saveGoals(selected.toList());
    await service.saveProfileName(nameController.text.trim());
    if (photoPath != null) {
      await service.saveProfilePhotoPath(photoPath!);
    }
    await service.completeOnboarding();
    if (mounted) widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    if (page == 0) return _welcomePage();
    if (page == 1) return _goalsPage();
    return _profilePage();
  }

  Widget _welcomePage() {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Text('EVERMORE', style: TextStyle(letterSpacing: 2, fontSize: 12, fontWeight: FontWeight.w800, color: EvermoreTheme.primary)),
              const SizedBox(height: 14),
              const Text('Keep becoming.', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800, height: 1.05)),
              const SizedBox(height: 14),
              const Text('A practical growth program for people who want to learn, apply and become better on purpose.', style: TextStyle(fontSize: 15, height: 1.55, color: EvermoreTheme.muted)),
              const Spacer(),
              NeoPillButton(
                label: 'Build my growth path',
                onPressed: () => setState(() => page = 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _goalsPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your growth goals', style: TextStyle(fontWeight: FontWeight.w800)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => setState(() => page = 0),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          const _StepIndicator(step: 1, total: 3),
          const SizedBox(height: 18),
          const Text('What do you want to improve?', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text('Choose as many as you want. Evermore will use them to shape your learning experience.', style: TextStyle(color: EvermoreTheme.muted, height: 1.45)),
          const SizedBox(height: 22),
          ...goals.map((goal) {
            final isSelected = selected.contains(goal);
            return GestureDetector(
              onTap: () => setState(() => isSelected ? selected.remove(goal) : selected.add(goal)),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? EvermoreTheme.primary.withValues(alpha: .07) : Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: isSelected ? EvermoreTheme.primary : EvermoreTheme.border),
                  boxShadow: isSelected ? EvermoreTheme.cardShadow : null,
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(goal, style: const TextStyle(fontWeight: FontWeight.w700))),
                    Icon(isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      color: isSelected ? EvermoreTheme.primary : EvermoreTheme.muted),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          NeoPillButton(
            label: 'Continue',
            onPressed: selected.isEmpty ? null : () => setState(() => page = 2),
          ),
        ],
      ),
    );
  }

  Widget _profilePage() {
    final canFinish = nameController.text.trim().isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set up your profile', style: TextStyle(fontWeight: FontWeight.w800)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => setState(() => page = 1),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _StepIndicator(step: 2, total: 3),
              const SizedBox(height: 18),
              const Text("This is how you'll show up", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text("Add your name and, if you'd like, a photo. This stays on your device only.", style: TextStyle(color: EvermoreTheme.muted, height: 1.45)),
              const SizedBox(height: 32),
              Center(
                child: AvatarPicker(
                  photoPath: photoPath,
                  name: nameController.text,
                  size: 108,
                  onChanged: (path) => setState(() => photoPath = path),
                ),
              ),
              const SizedBox(height: 28),
              const Text('Your name', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(fontWeight: FontWeight.w600),
                decoration: const InputDecoration(
                  hintText: 'e.g. Akin Diormi',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const Spacer(),
              NeoPillButton(
                label: 'Start Evermore',
                onPressed: canFinish ? finish : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int step;
  final int total;
  const _StepIndicator({required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final active = i <= step;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i == total - 1 ? 0 : 6),
            height: 4,
            decoration: BoxDecoration(
              color: active ? EvermoreTheme.primary : EvermoreTheme.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
