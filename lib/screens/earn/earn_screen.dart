import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
import '../../core/widgets/evermore_background.dart';
import '../../models/reward_task.dart';
import '../../services/task_service.dart';
import '../wallet/wallet_screen.dart';
import 'task_detail_screen.dart';

class EarnScreen extends StatefulWidget {
  const EarnScreen({super.key});

  @override
  State<EarnScreen> createState() => _EarnScreenState();
}

class _EarnScreenState extends State<EarnScreen> {
  final _taskService = TaskService();
  List<RewardTask>? _tasks;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final tasks = await _taskService.getTasks();
    if (mounted) setState(() => _tasks = tasks);
  }

  @override
  Widget build(BuildContext context) {
    return EvermoreBackground(
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 125),
            children: [
              const Text('EARN', style: TextStyle(fontSize: 10, letterSpacing: 1.7, fontWeight: FontWeight.w900, color: EvermoreTheme.primary)),
              const SizedBox(height: 6),
              const Text('Complete tasks, get paid.', style: TextStyle(fontSize: 28, height: 1, fontWeight: FontWeight.w800, letterSpacing: -.9)),
              const SizedBox(height: 8),
              const Text(
                'Every reward here is only credited once a task is verified. Withdraw anytime — no fees, no unlock step.',
                style: TextStyle(color: EvermoreTheme.muted, height: 1.45, fontSize: 13.5),
              ),
              const SizedBox(height: 18),
              _WalletShortcut(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()))),
              const SizedBox(height: 22),
              const Text('AVAILABLE TASKS', style: TextStyle(fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w900, color: EvermoreTheme.primary)),
              const SizedBox(height: 11),
              if (_tasks == null)
                const Padding(padding: EdgeInsets.only(top: 40), child: Center(child: CircularProgressIndicator()))
              else
                ..._tasks!.map((task) => _TaskCard(
                      task: task,
                      onTap: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)));
                        _load();
                      },
                    )),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletShortcut extends StatelessWidget {
  final VoidCallback onTap;
  const _WalletShortcut({required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(gradient: EvermoreTheme.heroGradient, borderRadius: BorderRadius.circular(24), boxShadow: EvermoreTheme.cardShadow),
            child: const Row(children: [
              Icon(Icons.account_balance_wallet_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('View wallet & withdraw', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
              ),
              Icon(Icons.arrow_outward_rounded, color: Colors.white, size: 18),
            ]),
          ),
        ),
      );
}

class _TaskCard extends StatelessWidget {
  final RewardTask task;
  final VoidCallback onTap;
  const _TaskCard({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final verified = task.status == TaskStatus.verified;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: verified ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.all(15),
            decoration: EvermoreTheme.glassCard(radius: 20),
            child: Row(children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(gradient: EvermoreTheme.softGradient, borderRadius: BorderRadius.circular(14)),
                child: Icon(verified ? Icons.check_circle_rounded : Icons.task_alt_rounded, color: EvermoreTheme.primary, size: 19),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(task.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(task.category, style: const TextStyle(fontSize: 10.5, color: EvermoreTheme.muted)),
                ]),
              ),
              Text(
                verified ? 'Verified' : '₦${task.rewardNaira}',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: verified ? EvermoreTheme.muted : EvermoreTheme.primary),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
