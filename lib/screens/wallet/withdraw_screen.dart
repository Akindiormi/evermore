import 'package:flutter/material.dart';
import '../../core/theme/evermore_theme.dart';
import '../../core/widgets/evermore_background.dart';
import '../../services/wallet_service.dart';

class WithdrawScreen extends StatefulWidget {
  final int balance;
  const WithdrawScreen({super.key, required this.balance});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _wallet = WalletService();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  bool _submitting = false;
  bool _done = false;

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_bankNameController.text.trim().isEmpty || _accountNumberController.text.trim().isEmpty) return;
    setState(() => _submitting = true);
    final last4 = _accountNumberController.text.trim();
    final label = '${_bankNameController.text.trim()} ****${last4.length >= 4 ? last4.substring(last4.length - 4) : last4}';
    // TODO (backend): POST /withdrawals with the real account number for
    // Paystack/Flutterwave transfer or manual bank payout, then poll or
    // receive a push for status updates (processing -> paid).
    await _wallet.requestWithdrawal(amountNaira: widget.balance, bankLabel: label);
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _done = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return EvermoreBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
                const Text('Withdraw', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 16),
              if (_done) ...[
                const SizedBox(height: 40),
                const Icon(Icons.check_circle_rounded, color: Colors.green, size: 56),
                const SizedBox(height: 16),
                const Text('Withdrawal requested', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('₦${widget.balance} is on its way to your bank account. No fee was charged.', style: const TextStyle(color: EvermoreTheme.muted, height: 1.4)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: EvermoreTheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: EvermoreTheme.glassCard(radius: 20, color: Colors.white.withValues(alpha: .72)),
                  child: Row(children: [
                    const Text('Withdrawing', style: TextStyle(color: EvermoreTheme.muted, fontSize: 13)),
                    const Spacer(),
                    Text('₦${widget.balance}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: EvermoreTheme.primary)),
                  ]),
                ),
                const SizedBox(height: 20),
                const Text('Bank name', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                const SizedBox(height: 6),
                TextField(controller: _bankNameController, decoration: const InputDecoration(hintText: 'e.g. GTBank')),
                const SizedBox(height: 14),
                const Text('Account number', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                const SizedBox(height: 6),
                TextField(controller: _accountNumberController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: '10-digit NUBAN')),
                const SizedBox(height: 22),
                const Text('Full balance is transferred — no withdrawal fee, no minimum, no upgrade required.', style: TextStyle(fontSize: 11.5, color: EvermoreTheme.muted)),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(backgroundColor: EvermoreTheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                    child: _submitting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Confirm withdrawal', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
