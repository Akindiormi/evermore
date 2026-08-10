import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
import '../../services/progress_service.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final selected = <String>{};
  int page = 0;

  final goals = const [
    'Personal development', 'Mindset', 'Productivity', 'Communication',
    'Financial literacy', 'Career growth', 'Digital skills', 'Leadership',
    'Goal setting', 'Discipline',
  ];

  void finish() async {
    final service = ProgressService();
    await service.saveGoals(selected.toList());
    await service.completeOnboarding();
    if (mounted) widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    if (page == 0) {
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
                SizedBox(width: double.infinity, child: FilledButton(
                  onPressed: () => setState(() => page = 1),
                  style: FilledButton.styleFrom(backgroundColor: EvermoreTheme.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Build my growth path', style: TextStyle(fontWeight: FontWeight.w800)),
                )),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your growth goals', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
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
          SizedBox(width: double.infinity, child: FilledButton(
            onPressed: selected.isEmpty ? null : finish,
            style: FilledButton.styleFrom(backgroundColor: EvermoreTheme.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Start Evermore', style: TextStyle(fontWeight: FontWeight.w800)),
          )),
        ],
      ),
    );
  }
}
