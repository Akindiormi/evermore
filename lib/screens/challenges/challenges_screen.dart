import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Growth challenges', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          const Text('Learn it. Apply it.', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
          const SizedBox(height: 7),
          const Text('Challenges turn learning into behaviour.', style: TextStyle(color: EvermoreTheme.muted)),
          const SizedBox(height: 22),
          ...growthChallenges.map((challenge) => GestureDetector(
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => ChallengeDetailScreen(challenge: challenge, alreadyCompleted: completed.contains(challenge.id))));
              _load();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(19), border: Border.all(color: EvermoreTheme.border)),
              child: Row(children: [
                Container(width: 45, height: 45, decoration: BoxDecoration(color: EvermoreTheme.primary.withValues(alpha: .08), borderRadius: BorderRadius.circular(13)),
                  child: Icon(completed.contains(challenge.id) ? Icons.check_rounded : Icons.track_changes_outlined, color: EvermoreTheme.primary)),
                const SizedBox(width: 13),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(challenge.category.toUpperCase(), style: const TextStyle(fontSize: 9, letterSpacing: .8, color: EvermoreTheme.primary, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(challenge.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(challenge.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: EvermoreTheme.muted)),
                ])),
                const Icon(Icons.chevron_right_rounded, color: EvermoreTheme.muted),
              ]),
            ),
          )),
        ],
      ),
    );
  }
}

class ChallengeDetailScreen extends StatelessWidget {
  final GrowthChallenge challenge;
  final bool alreadyCompleted;
  const ChallengeDetailScreen({super.key, required this.challenge, required this.alreadyCompleted});

  Future<void> complete(BuildContext context) async {
    await ProgressService().completeChallenge(challenge.id, xp: challenge.xp);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('+${challenge.xp} XP earned')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Challenge', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [EvermoreTheme.primary, EvermoreTheme.primaryDark]), borderRadius: BorderRadius.circular(24)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(challenge.category.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text(challenge.title, style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text(challenge.description, style: const TextStyle(color: Colors.white70, height: 1.5)),
            ]),
          ),
          const SizedBox(height: 25),
          const Text('How it works', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
          const SizedBox(height: 15),
          ...challenge.steps.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 29, height: 29, decoration: BoxDecoration(color: EvermoreTheme.primary.withValues(alpha: .08), shape: BoxShape.circle),
                child: Center(child: Text('${e.key + 1}', style: const TextStyle(color: EvermoreTheme.primary, fontWeight: FontWeight.w800, fontSize: 11)))),
              const SizedBox(width: 11),
              Expanded(child: Text(e.value, style: const TextStyle(fontSize: 13, height: 1.45))),
            ]),
          )),
          const SizedBox(height: 10),
          NeoPillButton(
            label: alreadyCompleted ? 'Challenge completed' : 'Complete challenge +${challenge.xp} XP',
            onPressed: alreadyCompleted ? null : () => complete(context),
          ),
        ],
      ),
    );
  }
}
