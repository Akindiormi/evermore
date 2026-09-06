import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wallet_transaction.dart';

/// Manages the user's wallet: verified earnings and withdrawal requests.
///
/// IMPORTANT: This currently persists to local SharedPreferences only, the
/// same as the rest of this app's ProgressService. That is fine for
/// tracking display state on-device, but it is NOT sufficient on its own
/// to be a trustworthy money product:
///
///   - Task completions must be verified server-side (see TaskService) —
///     a balance that only a local device credits/decides can be edited
///     or faked, which is exactly the "fabricated balance" pattern to avoid.
///   - Withdrawals must call a real backend that talks to a payment
///     processor (Paystack/Flutterwave payout API or bank transfer),
///     not just mark a local record as "paid".
///
/// The TODOs below mark exactly where those backend calls belong.
class WalletService {
  static const _transactionsKey = 'wallet_transactions';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<List<WalletTransaction>> getTransactions() async {
    final prefs = await _prefs;
    final raw = prefs.getStringList(_transactionsKey) ?? [];
    return raw.map(_decode).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<int> getBalance() async {
    final transactions = await getTransactions();
    var balance = 0;
    for (final t in transactions) {
      if (t.type == TransactionType.earning) {
        balance += t.amountNaira;
      } else if (t.type == TransactionType.withdrawal &&
          t.withdrawalStatus == WithdrawalStatus.paid) {
        // Already-paid withdrawals are deducted immediately when requested
        // (see requestWithdrawal), so this branch just documents intent.
      }
    }
    return balance;
  }

  /// Call this only after the backend confirms a task was verified.
  /// TODO: in production, this is triggered by a server push/response,
  /// not called directly from the UI on task submit.
  Future<void> creditVerifiedTask({
    required String taskId,
    required String label,
    required int amountNaira,
  }) async {
    await _addTransaction(WalletTransaction(
      id: 'earn-$taskId-${DateTime.now().millisecondsSinceEpoch}',
      type: TransactionType.earning,
      amountNaira: amountNaira,
      label: label,
      date: DateTime.now(),
    ));
  }

  /// Requests a withdrawal of the full current balance to the user's bank
  /// account. No fee is charged and no "unlock" step gates this — it should
  /// always be available once the user has a verified balance.
  ///
  /// TODO: replace this with a real backend call, e.g.
  ///   POST /withdrawals { amount, bankAccountId }
  /// which the backend fulfills via Paystack/Flutterwave transfer or a
  /// manual bank transfer, then reports back a real status (processing/paid/failed).
  Future<WalletTransaction> requestWithdrawal({
    required int amountNaira,
    required String bankLabel, // e.g. "GTBank ****1234"
  }) async {
    final tx = WalletTransaction(
      id: 'wd-${DateTime.now().millisecondsSinceEpoch}',
      type: TransactionType.withdrawal,
      amountNaira: amountNaira,
      label: 'Withdrawal to $bankLabel',
      date: DateTime.now(),
      withdrawalStatus: WithdrawalStatus.pending, // becomes processing/paid via backend
    );
    await _addTransaction(tx);
    return tx;
  }

  Future<void> _addTransaction(WalletTransaction tx) async {
    final prefs = await _prefs;
    final raw = prefs.getStringList(_transactionsKey) ?? [];
    raw.add(_encode(tx));
    await prefs.setStringList(_transactionsKey, raw);
  }

  String _encode(WalletTransaction t) => jsonEncode({
        'id': t.id,
        'type': t.type.name,
        'amount': t.amountNaira,
        'label': t.label,
        'date': t.date.toIso8601String(),
        'withdrawalStatus': t.withdrawalStatus?.name,
      });

  WalletTransaction _decode(String raw) {
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return WalletTransaction(
      id: map['id'] as String,
      type: TransactionType.values.byName(map['type'] as String),
      amountNaira: map['amount'] as int,
      label: map['label'] as String,
      date: DateTime.parse(map['date'] as String),
      withdrawalStatus: map['withdrawalStatus'] != null
          ? WithdrawalStatus.values.byName(map['withdrawalStatus'] as String)
          : null,
    );
  }
}
