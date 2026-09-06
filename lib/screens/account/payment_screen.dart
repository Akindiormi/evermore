import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/app_config.dart';
import '../../core/theme/evermore_theme.dart';
import '../../core/widgets/evermore_background.dart';
import '../../models/app_package.dart';
import '../../services/account_service.dart';
import 'payment_pending_screen.dart';

class PaymentScreen extends StatefulWidget {
  final AppPackage package;
  const PaymentScreen({super.key, required this.package});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  XFile? _receipt;
  bool _submitting = false;

  Future<void> _pickReceipt() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 88);
    if (picked != null && mounted) setState(() => _receipt = picked);
  }

  Future<void> _submit() async {
    if (_receipt == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select your payment receipt first')));
      return;
    }
    setState(() => _submitting = true);
    await AccountService().saveReceipt(_receipt!.path);
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const PaymentPendingScreen()), (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: EvermoreBackground(child: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(20, 12, 20, 35), children: [
        const Text('Complete your activation', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -.7)),
        const SizedBox(height: 7),
        const Text('Make the transfer using the configured payment details below, then submit your receipt.', style: TextStyle(color: EvermoreTheme.muted, fontSize: 13.5, height: 1.4)),
        const SizedBox(height: 22),
        _InfoCard(title: 'Selected package', icon: Icons.workspace_premium_outlined, child: Row(children: [Expanded(child: Text(widget.package.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16))), Text(widget.package.formattedPrice, style: const TextStyle(fontWeight: FontWeight.w900, color: EvermoreTheme.primary, fontSize: 17))])),
        const SizedBox(height: 12),
        _InfoCard(title: 'Bank transfer details', icon: Icons.account_balance_outlined, child: Column(children: [
          _Detail('Bank name', AppConfig.bankName), _Detail('Account name', AppConfig.accountName), _Detail('Account number', AppConfig.accountNumber),
        ])),
        const SizedBox(height: 12),
        _InfoCard(title: 'Payment instructions', icon: Icons.receipt_long_outlined, child: Text(AppConfig.paymentInstructions, style: const TextStyle(fontSize: 12, color: EvermoreTheme.muted, height: 1.45))),
        const SizedBox(height: 22),
        const Text('Payment receipt', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 5),
        const Text('Upload an image of your transfer receipt. You can review it before submitting.', style: TextStyle(fontSize: 11, color: EvermoreTheme.muted)),
        const SizedBox(height: 12),
        if (_receipt == null) _UploadBox(onTap: _pickReceipt) else _ReceiptPreview(file: File(_receipt!.path), onChange: _pickReceipt),
        const SizedBox(height: 18),
        SizedBox(height: 52, child: FilledButton.icon(onPressed: _submitting ? null : _submit, icon: const Icon(Icons.cloud_upload_outlined), label: Text(_submitting ? 'Submitting...' : 'Submit Payment Proof', style: const TextStyle(fontWeight: FontWeight.w800)), style: FilledButton.styleFrom(backgroundColor: EvermoreTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))))),
        const SizedBox(height: 10),
        const Text('Submission means proof has been received. It does not mean payment has been verified or approved.', textAlign: TextAlign.center, style: TextStyle(fontSize: 10.5, color: EvermoreTheme.muted, height: 1.4)),
      ]))),
    );
  }
}

class _InfoCard extends StatelessWidget { final String title; final IconData icon; final Widget child; const _InfoCard({required this.title, required this.icon, required this.child}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(17), decoration: EvermoreTheme.glassCard(radius: 21, color: Colors.white.withValues(alpha: .74)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(icon, color: EvermoreTheme.primary, size: 19), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14))]), const SizedBox(height: 13), child])); }
class _Detail extends StatelessWidget { final String label, value; const _Detail(this.label, this.value); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 105, child: Text(label, style: const TextStyle(fontSize: 10.5, color: EvermoreTheme.muted))), Expanded(child: Text(value, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)))])); }
class _UploadBox extends StatelessWidget { final VoidCallback onTap; const _UploadBox({required this.onTap}); @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(21), child: Ink(decoration: EvermoreTheme.glassCard(radius: 21, color: Colors.white.withValues(alpha: .72)), padding: const EdgeInsets.all(26), child: const Column(children: [Icon(Icons.upload_file_rounded, color: EvermoreTheme.primary, size: 30), SizedBox(height: 10), Text('Choose receipt image', style: TextStyle(fontWeight: FontWeight.w800)), SizedBox(height: 4), Text('JPG, PNG or similar image', style: TextStyle(fontSize: 10.5, color: EvermoreTheme.muted))]))); }
class _ReceiptPreview extends StatelessWidget { final File file; final VoidCallback onChange; const _ReceiptPreview({required this.file, required this.onChange}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(10), decoration: EvermoreTheme.glassCard(radius: 21, color: Colors.white.withValues(alpha: .72)), child: Column(children: [ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.file(file, height: 210, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox(height: 210, child: Center(child: Icon(Icons.broken_image_outlined)))), const SizedBox(height: 9), TextButton.icon(onPressed: onChange, icon: const Icon(Icons.swap_horiz_rounded), label: const Text('Choose a different receipt'))])); }
