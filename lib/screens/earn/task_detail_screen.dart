import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
import '../../core/widgets/evermore_background.dart';
import '../../models/reward_task.dart';
import '../../services/task_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final RewardTask task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _taskService = TaskService();
  bool _submitting = false;
  bool _done = false;

  Future<void> _submit() async {
    setState(() => _submitting = true);
    // TODO (backend): this should POST the task response for review and
    // wait for a verified/rejected result, not credit instantly.
    await _taskService.submitTask(widget.task);
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _done = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    return EvermoreBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: EvermoreTheme.primaryLight, borderRadius: BorderRadius.circular(20)),
                  child: Text(task.category, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: EvermoreTheme.primary)),
                ),
              ]),
              const SizedBox(height: 12),
              Text(task.title, style: const TextStyle(fontSize: 26, height: 1.1, fontWeight: FontWeight.w800, letterSpacing: -.7)),
              const SizedBox(height: 10),
              Text(task.description, style: const TextStyle(color: EvermoreTheme.muted, height: 1.5, fontSize: 14)),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: EvermoreTheme.glassCard(radius: 20, color: Colors.white.withValues(alpha: .72)),
                child: Row(children: [
                  const Icon(Icons.payments_rounded, color: EvermoreTheme.primary),
                  const SizedBox(width: 10),
                  Text('Reward: ₦${task.rewardNaira}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  const Spacer(),
                  const Text('Credited after verification', style: TextStyle(fontSize: 10.5, color: EvermoreTheme.muted)),
                ]),
              ),
              const Spacer(),
              if (_done)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.green.withValues(alpha: .1), borderRadius: BorderRadius.circular(16)),
                  child: const Row(children: [
                    Icon(Icons.check_circle_rounded, color: Colors.green),
                    SizedBox(width: 10),
                    Expanded(child: Text('Submitted — you\'ll see this reflected in your wallet once verified.', style: TextStyle(fontSize: 12.5))),
                  ]),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EvermoreTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    child: _submitting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Submit task', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
