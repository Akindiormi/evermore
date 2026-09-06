import 'package:shared_preferences/shared_preferences.dart';
import '../data/reward_task_data.dart';
import '../models/reward_task.dart';
import 'wallet_service.dart';

/// Handles fetching tasks and submitting completions for verification.
///
/// TODO (backend): `getTasks()` should call GET /tasks instead of reading
/// the local sample list, and `submitTask()` should call
/// POST /tasks/{id}/submit and wait for a verified/rejected response
/// rather than auto-crediting immediately. Auto-crediting on submit (as
/// this stub does) is a placeholder for local demo/testing only — it is
/// NOT how verified, trustworthy earnings should work in production.
class TaskService {
  static const _submittedKey = 'submitted_task_ids';
  final _wallet = WalletService();

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<List<RewardTask>> getTasks() async {
    final submitted = await _submittedIds();
    return sampleRewardTasks
        .map((t) => submitted.contains(t.id)
            ? t.copyWith(status: TaskStatus.verified)
            : t)
        .toList();
  }

  Future<Set<String>> _submittedIds() async {
    final prefs = await _prefs;
    return (prefs.getStringList(_submittedKey) ?? []).toSet();
  }

  /// Marks a task as submitted and (in this local stub only) immediately
  /// credits the wallet. Replace the credit call with a real verification
  /// wait once a backend exists.
  Future<void> submitTask(RewardTask task) async {
    final prefs = await _prefs;
    final submitted = await _submittedIds();
    if (submitted.add(task.id)) {
      await prefs.setStringList(_submittedKey, submitted.toList());
      await _wallet.creditVerifiedTask(
        taskId: task.id,
        label: task.title,
        amountNaira: task.rewardNaira,
      );
    }
  }
}
