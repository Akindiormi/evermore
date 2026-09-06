enum TransactionType { earning, withdrawal }

enum WithdrawalStatus { pending, processing, paid, failed }

class WalletTransaction {
  final String id;
  final TransactionType type;
  final int amountNaira;
  final String label; // e.g. task title, or "Withdrawal to GTBank ****1234"
  final DateTime date;
  final WithdrawalStatus? withdrawalStatus; // only set for withdrawals

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amountNaira,
    required this.label,
    required this.date,
    this.withdrawalStatus,
  });
}
