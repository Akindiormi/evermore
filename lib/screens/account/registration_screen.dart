import 'package:flutter/material.dart';

import '../../core/theme/evermore_theme.dart';
import '../../core/widgets/evermore_background.dart';
import '../../services/account_service.dart';
import '../../services/telegram_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  String _country = 'Nigeria';
  bool _obscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email address is required';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length < 7 || digits.length > 15) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    final v = value ?? '';
    if (v.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(v) ||
        !RegExp(r'[a-z]').hasMatch(v) ||
        !RegExp(r'\d').hasMatch(v)) {
      return 'Password must meet the requirements below';
    }
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate() || _submitting) return;

    setState(() => _submitting = true);

    final name = _name.text.trim();
    final email = _email.text.trim();
    final phone = _phone.text.trim();
    final country = _country;

    await AccountService().saveAccount(
      name: name,
      email: email,
      phone: phone,
      country: country,
    );

    if (!mounted) return;

    final opened = await TelegramService.openActivationDraft(
      name: name,
      email: email,
      phone: phone,
      country: country,
    );

    if (!mounted) return;

    setState(() => _submitting = false);

    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Telegram could not be opened. Please try again.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your activation details are ready to send in Telegram.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create your account')),
      body: EvermoreBackground(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 35),
              children: [
                const Text(
                  'Activate your account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.7,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Enter your details to request account activation. No payment is required in the app.',
                  style: TextStyle(
                    color: EvermoreTheme.muted,
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                _label('Full name'),
                _field(
                  _name,
                  hint: 'Your full name',
                  validator: (v) => (v?.trim().isEmpty ?? true)
                      ? 'Full name is required'
                      : null,
                ),
                _label('Email address'),
                _field(
                  _email,
                  hint: 'you@example.com',
                  keyboard: TextInputType.emailAddress,
                  validator: _emailValidator,
                ),
                _label('Phone number'),
                _field(
                  _phone,
                  hint: '+234 800 000 0000',
                  keyboard: TextInputType.phone,
                  validator: _phoneValidator,
                ),
                _label('Password'),
                TextFormField(
                  controller: _password,
                  obscureText: _obscure,
                  validator: _passwordValidator,
                  decoration: InputDecoration(
                    hintText: 'Create a strong password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Password requirements: 8+ characters, uppercase, lowercase and a number.',
                  style: TextStyle(
                    fontSize: 11,
                    color: EvermoreTheme.muted,
                    height: 1.4,
                  ),
                ),
                _label('Country'),
                DropdownButtonFormField<String>(
                  value: _country,
                  items: const [
                    DropdownMenuItem(value: 'Nigeria', child: Text('Nigeria')),
                    DropdownMenuItem(value: 'Ghana', child: Text('Ghana')),
                    DropdownMenuItem(value: 'Kenya', child: Text('Kenya')),
                    DropdownMenuItem(
                      value: 'South Africa',
                      child: Text('South Africa'),
                    ),
                    DropdownMenuItem(
                      value: 'United Kingdom',
                      child: Text('United Kingdom'),
                    ),
                    DropdownMenuItem(
                      value: 'United States',
                      child: Text('United States'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _country = v ?? 'Nigeria'),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _submitting ? null : _submit,
                    icon: const Icon(Icons.send_rounded),
                    label: Text(
                      _submitting
                          ? 'Preparing activation...'
                          : 'Request Activation',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: EvermoreTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 17, bottom: 8),
        child: Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      );

  Widget _field(
    TextEditingController controller, {
    required String hint,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboard,
        textCapitalization: TextCapitalization.words,
        validator: validator,
        decoration: InputDecoration(hintText: hint),
      );
}
