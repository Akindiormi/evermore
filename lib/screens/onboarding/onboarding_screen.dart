import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/evermore_theme.dart';
import '../../core/widgets/evermore_background.dart';
import '../../core/widgets/evermore_mark.dart';
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
  bool saving = false;

  final goals = const ['Personal development', 'Mindset', 'Productivity', 'Communication', 'Financial literacy', 'Career growth', 'Digital skills', 'Leadership', 'Goal setting', 'Discipline'];

  @override
  void dispose() { nameController.dispose(); super.dispose(); }

  Future<void> finish() async {
    if (saving) return;
    setState(() => saving = true);
    HapticFeedback.mediumImpact();
    final service = ProgressService();
    await service.saveGoals(selected.toList());
    await service.saveProfileName(nameController.text.trim());
    if (photoPath != null) await service.saveProfilePhotoPath(photoPath!);
    await service.completeOnboarding();
    if (mounted) widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    if (page == 0) return _welcomePage();
    if (page == 1) return _goalsPage();
    return _profilePage();
  }

  Widget _welcomePage() => Scaffold(
    body: EvermoreBackground(child: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(24, 24, 24, 28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Spacer(),
      Center(child: Container(width: 116, height: 116, padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: EvermoreTheme.logoGradient, borderRadius: BorderRadius.circular(34), boxShadow: EvermoreTheme.floatingShadow), child: const EvermoreMark(size: 68, color: Colors.white))),
      const SizedBox(height: 40),
      const Text('EVERMORE', style: TextStyle(letterSpacing: 2, fontSize: 11, fontWeight: FontWeight.w900, color: EvermoreTheme.primary)),
      const SizedBox(height: 10),
      const Text('Keep becoming.', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, height: 1.02, letterSpacing: -1.2)),
      const SizedBox(height: 14),
      const Text('A practical growth program for people who want to learn, apply and become better on purpose.', style: TextStyle(fontSize: 14, height: 1.55, color: EvermoreTheme.muted)),
      const Spacer(),
      NeoPillButton(label: 'Build my growth path', icon: Icons.arrow_forward_rounded, onPressed: () => setState(() => page = 1)),
    ]))),
  );

  Widget _goalsPage() => Scaffold(
    appBar: AppBar(title: const Text('Your growth goals'), leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => setState(() => page = 0))),
    body: EvermoreBackground(child: ListView(padding: const EdgeInsets.fromLTRB(20, 10, 20, 30), children: [
      const _StepIndicator(step: 1, total: 3),
      const SizedBox(height: 18),
      const Text('What do you want to improve?', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, letterSpacing: -.5)),
      const SizedBox(height: 8),
      const Text('Choose as many as you want. Evermore will use them to shape your learning experience.', style: TextStyle(color: EvermoreTheme.muted, height: 1.45, fontSize: 12.5)),
      const SizedBox(height: 20),
      ...goals.map((goal) {
        final isSelected = selected.contains(goal);
        return Padding(padding: const EdgeInsets.only(bottom: 9), child: Material(color: Colors.transparent, child: InkWell(borderRadius: BorderRadius.circular(18), onTap: () { HapticFeedback.selectionClick(); setState(() => isSelected ? selected.remove(goal) : selected.add(goal)); }, child: Ink(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: isSelected ? EvermoreTheme.primary.withValues(alpha: .075) : Colors.white.withValues(alpha: .72), borderRadius: BorderRadius.circular(18), border: Border.all(color: isSelected ? EvermoreTheme.primary : EvermoreTheme.divider), boxShadow: isSelected ? EvermoreTheme.cardShadow : const []), child: Row(children: [Expanded(child: Text(goal, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5))), Icon(isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: isSelected ? EvermoreTheme.primary : EvermoreTheme.muted)])))));
      }),
      const SizedBox(height: 10),
      NeoPillButton(label: 'Continue', icon: Icons.arrow_forward_rounded, onPressed: selected.isEmpty ? null : () => setState(() => page = 2)),
    ])),
  );

  Widget _profilePage() {
    final canFinish = nameController.text.trim().isNotEmpty && !saving;
    return Scaffold(
      appBar: AppBar(title: const Text('Set up your profile'), leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: saving ? null : () => setState(() => page = 1))),
      body: EvermoreBackground(child: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 10, 20, 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const _StepIndicator(step: 2, total: 3),
        const SizedBox(height: 18),
        const Text("This is how you'll show up", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, letterSpacing: -.5)),
        const SizedBox(height: 8),
        const Text("Add your name and, if you'd like, a photo. This stays on your device only.", style: TextStyle(color: EvermoreTheme.muted, height: 1.45, fontSize: 12.5)),
        const SizedBox(height: 30),
        Center(child: AvatarPicker(photoPath: photoPath, name: nameController.text, size: 108, onChanged: (path) => setState(() => photoPath = path))),
        const SizedBox(height: 26),
        const Text('Your name', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(controller: nameController, textCapitalization: TextCapitalization.words, onChanged: (_) => setState(() {}), style: const TextStyle(fontWeight: FontWeight.w600), decoration: const InputDecoration(hintText: 'e.g. Akin Diormi', prefixIcon: Icon(Icons.badge_outlined))),
        const Spacer(),
        NeoPillButton(label: saving ? 'Creating your path...' : 'Start Evermore', icon: Icons.arrow_forward_rounded, onPressed: canFinish ? finish : null),
      ]))),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int step, total;
  const _StepIndicator({required this.step, required this.total});
  @override
  Widget build(BuildContext context) => Row(children: List.generate(total, (i) => Expanded(child: Container(margin: EdgeInsets.only(right: i == total - 1 ? 0 : 6), height: 4, decoration: BoxDecoration(color: i <= step ? EvermoreTheme.primary : EvermoreTheme.primary.withValues(alpha: .10), borderRadius: BorderRadius.circular(2))))));
}
