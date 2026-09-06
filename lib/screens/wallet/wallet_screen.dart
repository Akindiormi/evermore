import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
import '../../core/widgets/evermore_background.dart';
import '../../models/wallet_transaction.dart';
import '../../services/wallet_service.dart';
import 'withdraw_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _wallet = WalletService();
  int? _balance;
  List<WalletTransaction>? _transactions;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final balance = await _wallet.getBalance();
    final transactions = await _wallet.getTransactions();
    if (mounted) {
      setState(() {
        _balance = balance;
        _transactions = transactions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return EvermoreBackground(
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
            children: [
              Row(children: [
                IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
                const Text('Wallet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(gradient: EvermoreTheme.heroGradient, borderRadius: BorderRadius.circular(28), boxShadow: EvermoreTheme.cardShadow),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Available balance', style: TextStyle(color: Colors.white70, fontSize: 12.5)),
                  const SizedBox(height: 8),
                  Text(
                    _balance == null ? '—' : '₦${_balance!}',
                    style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (_balance ?? 0) <= 0
                          ? null
                          : () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (_) => WithdrawScreen(balance: _balance!)));
                              _load();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: EvermoreTheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Withdraw', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                child: Text('No withdrawal fee. No unlock step. Verified earnings are always yours.', style: TextStyle(fontSize: 11.5, color: EvermoreTheme.muted)),
              ),
              const SizedBox(height: 14),
              const Text('HISTORY', style: TextStyle(fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w900, color: EvermoreTheme.primary)),
              const SizedBox(height: 11),
              if (_transactions == null)
                const Padding(padding: EdgeInsets.only(top: 30), child: Center(child: CircularProgressIndicator()))
              else if (_transactions!.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('No activity yet. Complete a task to see it here.', style: TextStyle(color: EvermoreTheme.muted, fontSize: 13)),
                )
              else
                ..._transactions!.map((t) => _TransactionRow(t: t)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final WalletTransaction t;
  const _TransactionRow({required this.t});

  @override
  Widget build(BuildContext context) {
    final isEarning = t.type == TransactionType.earning;
    final statusLabel = t.withdrawalStatus == null
        ? null
        : switch (t.withdrawalStatus!) {
            WithdrawalStatus.pending => 'Pending',
            WithdrawalStatus.processing => 'Processing',
            WithdrawalStatus.paid => 'Paid',
            WithdrawalStatus.failed => 'Failed',
          };
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: EvermoreTheme.glassCard(radius: 20),
        child: Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(gradient: EvermoreTheme.softGradient, borderRadius: BorderRadius.circular(13)),
            child: Icon(isEarning ? Icons.add_rounded : Icons.arrow_upward_rounded, color: EvermoreTheme.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
              if (statusLabel != null) ...[
                const SizedBox(height: 3),
                Text(statusLabel, style: const TextStyle(fontSize: 10.5, color: EvermoreTheme.muted)),
              ],
            ]),
          ),
          Text(
            '${isEarning ? '+' : '-'}₦${t.amountNaira}',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: isEarning ? Colors.green.shade700 : EvermoreTheme.text),
          ),
        ]),
      ),
    );
  }
}
