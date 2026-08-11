import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/evermore_theme.dart';
import '../../core/widgets/evermore_background.dart';
import '../../core/widgets/evermore_mark.dart';
import '../../data/challenge_data.dart';
import '../../models/challenge.dart';
import '../../services/progress_service.dart';
import '../../widgets/neo_pill_button.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});
  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  Set<String> completed = {};
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final data = await ProgressService().completedChallenges();
    if (mounted) setState(() => completed = data);
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = growthChallenges.where((c) => completed.contains(c.id)).length;
    return Scaffold(
      appBar: AppBar(title: const Text('Growth challenges')),
      body: EvermoreBackground(
        child: RefreshIndicator(
          color: EvermoreTheme.primary,
          onRefresh: _load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 35),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(gradient: EvermoreTheme.heroGradient, borderRadius: BorderRadius.circular(28), boxShadow: EvermoreTheme.cardShadow),
                child: Stack(children: [
                  const Positioned(right: -5, top: -12, child: Opacity(opacity: .12, child: EvermoreMark(size: 95, color: Colors.white))),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('PUT IT INTO ACTION', style: TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 1.3, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    const Text('Learn it. Apply it.', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800, letterSpacing: -.5)),
                    const SizedBox(height: 7),
                    const Text('Challenges turn learning into behaviour.', style: TextStyle(color: Colors.white70, fontSize: 11.5, height: 1.4)),
                    const SizedBox(height: 15),
                    Text('$doneCount of ${growthChallenges.length} challenges completed', style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w700)),
                  ]),
                ]),
              ),
              const SizedBox(height: 22),
              ...growthChallenges.map((challenge) => _ChallengeCard(challenge: challenge, done: completed.contains(challenge.id), onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => ChallengeDetailScreen(challenge: challenge, alreadyCompleted: completed.contains(challenge.id)))); _load(); })),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final GrowthChallenge challenge;
  final bool done;
  final VoidCallback onTap;
  const _ChallengeCard({required this.challenge, required this.done, required this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: Material(color: Colors.transparent, child: InkWell(borderRadius: BorderRadius.circular(22), onTap: onTap, child: Ink(padding: const EdgeInsets.all(16), decoration: EvermoreTheme.glassCard(radius: 22, color: Colors.white.withValues(alpha: .72)), child: Row(children: [
      Container(width: 48, height: 48, decoration: BoxDecoration(gradient: done ? EvermoreTheme.logoGradient : EvermoreTheme.softGradient, borderRadius: BorderRadius.circular(16)), child: Icon(done ? Icons.check_rounded : Icons.track_changes_rounded, color: done ? Colors.white : EvermoreTheme.primary)),
      const SizedBox(width: 13),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(challenge.category.toUpperCase(), style: const TextStyle(fontSize: 8.5, letterSpacing: .9, color: EvermoreTheme.primary, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(challenge.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)), const SizedBox(height: 4), Text(challenge.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, height: 1.35, color: EvermoreTheme.muted))])),
      const SizedBox(width: 8),
      Column(children: [Text('+${challenge.xp}', style: const TextStyle(color: EvermoreTheme.primary, fontSize: 10, fontWeight: FontWeight.w900)), const SizedBox(height: 3), const Icon(Icons.chevron_right_rounded, color: EvermoreTheme.primary, size: 19)]),
    ]))));
}

class ChallengeDetailScreen extends StatefulWidget {
  final GrowthChallenge challenge;
  final bool alreadyCompleted;
  const ChallengeDetailScreen({super.key, required this.challenge, required this.alreadyCompleted});
  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  late bool completed = widget.alreadyCompleted;
  bool saving = false;

  Future<void> complete() async {
    if (saving || completed) return;
    setState(() => saving = true);
    HapticFeedback.mediumImpact();
    await ProgressService().completeChallenge(widget.challenge.id, xp: widget.challenge.xp);
    if (!mounted) return;
    setState(() { completed = true; saving = false; });
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('+${widget.challenge.xp} XP earned — challenge completed')));
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    return Scaffold(
      appBar: AppBar(title: const Text('Challenge')),
      body: EvermoreBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 35),
          children: [
            Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: EvermoreTheme.heroGradient, borderRadius: BorderRadius.circular(28), boxShadow: EvermoreTheme.cardShadow), child: Stack(children: [const Positioned(right: -5, top: -12, child: Opacity(opacity: .12, child: EvermoreMark(size: 95, color: Colors.white))), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(challenge.category.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w900)), const SizedBox(height: 9), Text(challenge.title, style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w800, letterSpacing: -.6)), const SizedBox(height: 9), Text(challenge.description, style: const TextStyle(color: Colors.white70, height: 1.5, fontSize: 11.5))])])),
            const SizedBox(height: 25),
            const Text('How it works', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 13),
            ...challenge.steps.asMap().entries.map((e) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(15), decoration: EvermoreTheme.glassCard(radius: 19, color: Colors.white.withValues(alpha: .72)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 30, height: 30, decoration: BoxDecoration(color: EvermoreTheme.primary.withValues(alpha: .08), shape: BoxShape.circle), child: Center(child: Text('${e.key + 1}', style: const TextStyle(color: EvermoreTheme.primary, fontWeight: FontWeight.w900, fontSize: 10)))), const SizedBox(width: 11), Expanded(child: Text(e.value, style: const TextStyle(fontSize: 12.5, height: 1.45)))]))),
            const SizedBox(height: 8),
            NeoPillButton(label: saving ? 'Saving...' : completed ? 'Challenge completed ✓' : 'Complete challenge +${challenge.xp} XP', icon: completed ? Icons.check_rounded : Icons.arrow_forward_rounded, onPressed: completed || saving ? null : complete),
          ],
        ),
      ),
    );
  }
}
