import 'package:flutter/material.dart';
import '../services/account_service.dart';
import '../services/telegram_service.dart';

class LioraPlatform extends StatefulWidget {
  const LioraPlatform({super.key});

  @override
  State<LioraPlatform> createState() => _LioraPlatformState();
}

enum _View { home, account, createAccount, membership }

class _LioraPlatformState extends State<LioraPlatform> {
  static const gold = Color(0xFFC58A19);
  static const ink = Color(0xFF111111);
  static const cream = Color(0xFFF7F5F0);

  _View view = _View.home;
  bool accountCreated = false;
  bool loading = true;
  String name = '';
  String email = '';
  String phone = '';
  String selectedPlan = '';
  String membershipStatus = 'Guest';

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadAccount();
  }

  Future<void> _loadAccount() async {
    final service = AccountService();
    final registered = await service.isRegistered();
    if (!mounted) return;
    if (registered) {
      name = await service.name;
      email = await service.email;
      phone = await service.phone;
      accountCreated = true;
      membershipStatus = 'Awaiting activation';
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!formKey.currentState!.validate()) return;
    final fullName = nameController.text.trim();
    final mail = emailController.text.trim();
    final mobile = phoneController.text.trim();
    await AccountService().saveAccount(
      name: fullName,
      email: mail,
      phone: mobile,
      country: 'Nigeria',
    );
    if (!mounted) return;
    setState(() {
      name = fullName;
      email = mail;
      phone = mobile;
      accountCreated = true;
      membershipStatus = 'Awaiting activation';
      view = _View.membership;
    });
    // Reuse the Telegram community destination configured in the main app.
    await TelegramService.openCommunity();
  }

  void _exploreMembership() {
    setState(() => view = accountCreated ? _View.membership : _View.createAccount);
  }

  void _selectPlan(String plan) {
    setState(() {
      selectedPlan = plan;
      membershipStatus = 'Awaiting activation';
      view = _View.account;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    if (loading) {
      return const Scaffold(
        backgroundColor: cream,
        body: Center(child: CircularProgressIndicator(color: gold)),
      );
    }

    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: Column(
          children: [
            _header(wide),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _page(wide),
                  ),
                ),
              ),
            ),
            if (!wide) _bottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _header(bool wide) => Container(
        height: 76,
        padding: EdgeInsets.symmetric(horizontal: wide ? 42 : 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFECE8DF))),
        ),
        child: Row(
          children: [
            Image.asset('assets/evermore_icon.png', width: 46, height: 46, fit: BoxFit.contain),
            const Spacer(),
            if (wide) ...[
              TextButton(
                onPressed: () => setState(() => view = _View.home),
                child: const Text('Home'),
              ),
              const SizedBox(width: 10),
              _accountButton(),
            ] else
              _statusPill(),
          ],
        ),
      );

  Widget _accountButton() => TextButton.icon(
        onPressed: () => setState(() => view = _View.account),
        icon: const Icon(Icons.person_outline_rounded),
        label: const Text('Account'),
        style: TextButton.styleFrom(foregroundColor: ink),
      );

  Widget _statusPill() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: membershipStatus == 'Premium'
              ? const Color(0xFFFFF0C7)
              : const Color(0xFFF1EFEA),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 7, color: membershipStatus == 'Premium' ? gold : Colors.grey),
            const SizedBox(width: 7),
            Text(
              membershipStatus == 'Awaiting activation' ? 'Pending' : membershipStatus,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      );

  Widget _page(bool wide) {
    switch (view) {
      case _View.home:
        return _home(wide);
      case _View.account:
        return _account(wide);
      case _View.createAccount:
        return _createAccountPage(wide);
      case _View.membership:
        return _membership(wide);
    }
  }

  Widget _home(bool wide) => SingleChildScrollView(
        key: const ValueKey('home'),
        padding: EdgeInsets.fromLTRB(wide ? 42 : 20, 30, wide ? 42 : 20, 34),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(wide ? 38 : 25),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF111111), Color(0xFF302719), Color(0xFF4A3617)],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 28, offset: Offset(0, 13))],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -8,
                    top: -12,
                    child: Opacity(
                      opacity: .11,
                      child: Image.asset('assets/evermore_icon.png', width: wide ? 230 : 150, height: wide ? 230 : 150),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 610),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('A WORLD OF POSSIBILITIES', style: TextStyle(color: Color(0xFFE4B64F), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2.2)),
                        const SizedBox(height: 15),
                        Text(
                          'Discover more.\nBecome more.',
                          style: TextStyle(color: Colors.white, fontSize: wide ? 46 : 36, height: 1.08, fontWeight: FontWeight.w900, letterSpacing: -1.7),
                        ),
                        const SizedBox(height: 13),
                        const Text(
                          'Explore experiences, take part in activities and find something new around every corner.',
                          style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.6),
                        ),
                        const SizedBox(height: 25),
                        FilledButton(
                          onPressed: _exploreMembership,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFE0AD3E),
                            foregroundColor: ink,
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                          ),
                          child: const Row(mainAxisSize: MainAxisSize.min, children: [
                            Text('Explore membership', style: TextStyle(fontWeight: FontWeight.w900)),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward_rounded, size: 17),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 34),
            const Text('Explore experiences', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: ink, letterSpacing: -.6)),
            const SizedBox(height: 7),
            const Text('A few ways to get involved.', style: TextStyle(color: Color(0xFF77736C), fontSize: 13)),
            const SizedBox(height: 17),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: wide ? 4 : 2,
              crossAxisSpacing: 13,
              mainAxisSpacing: 13,
              childAspectRatio: wide ? 1.42 : 1.28,
              children: [
                _experience(Icons.poll_rounded, 'Surveys', 'Share your point of view', const Color(0xFFF8EED8)),
                _experience(Icons.sports_esports_rounded, 'Games', 'Play and participate', const Color(0xFFEDE9F7)),
                _experience(Icons.play_circle_fill_rounded, 'Videos', 'Watch something new', const Color(0xFFE5EFF1)),
                _experience(Icons.bolt_rounded, 'Activities', 'Get involved and explore', const Color(0xFFF5E7E2)),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFECE8DF))),
              child: Row(
                children: [
                  Container(width: 46, height: 46, decoration: BoxDecoration(color: const Color(0xFFFFF3D7), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.workspace_premium_rounded, color: gold)),
                  const SizedBox(width: 14),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Your membership starts here', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                    SizedBox(height: 4),
                    Text('Create your account to view available plans.', style: TextStyle(color: Color(0xFF77736C), fontSize: 11)),
                  ])),
                  IconButton(onPressed: _exploreMembership, icon: const Icon(Icons.arrow_forward_rounded, color: gold)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Center(child: Text('Rewards and earnings are coming soon.', style: TextStyle(color: Color(0xFF8B867D), fontSize: 11))),
          ],
        ),
      );

  Widget _experience(IconData icon, String title, String subtitle, Color tint) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFECE8DF))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(width: 39, height: 39, decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: ink, size: 20)),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Color(0xFF817D75), fontSize: 10.5)),
          ]),
        ]),
      );

  Widget _createAccountPage(bool wide) => SingleChildScrollView(
        key: const ValueKey('create'),
        padding: EdgeInsets.fromLTRB(wide ? 42 : 20, 26, wide ? 42 : 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Container(
              padding: EdgeInsets.all(wide ? 32 : 23),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFECE8DF))),
              child: Form(
                key: formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _backButton('Back to home', () => setState(() => view = _View.home)),
                  const SizedBox(height: 20),
                  const Text('Create your account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -.8)),
                  const SizedBox(height: 8),
                  const Text('A few details first. You’ll choose your membership plan in the next step.', style: TextStyle(color: Color(0xFF77736C), fontSize: 13, height: 1.5)),
                  const SizedBox(height: 25),
                  _fieldLabel('Full name'),
                  _input(nameController, 'Enter your full name', icon: Icons.person_outline, validator: (v) => (v == null || v.trim().length < 2) ? 'Enter your full name' : null),
                  _fieldLabel('Email address'),
                  _input(emailController, 'you@example.com', icon: Icons.mail_outline, type: TextInputType.emailAddress, validator: (v) => (v == null || !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v.trim())) ? 'Enter a valid email address' : null),
                  _fieldLabel('Phone number'),
                  _input(phoneController, '+234 800 000 0000', icon: Icons.phone_outlined, type: TextInputType.phone, validator: (v) => (v == null || v.replaceAll(RegExp(r'\D'), '').length < 7) ? 'Enter a valid phone number' : null),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: _createAccount,
                      style: FilledButton.styleFrom(backgroundColor: ink, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('Continue to membership', style: TextStyle(fontWeight: FontWeight.w900)),
                        SizedBox(width: 9),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Preview account: details are stored on this device only. Secure sign-in and account verification will be connected before launch.', style: TextStyle(color: Color(0xFF89847B), fontSize: 10.5, height: 1.5)),
                ]),
              ),
            ),
          ),
        ),
      );

  Widget _fieldLabel(String label) => Padding(
        padding: const EdgeInsets.only(top: 17, bottom: 8),
        child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
      );

  Widget _input(TextEditingController controller, String hint, {required IconData icon, TextInputType? type, String? Function(String?)? validator}) => TextFormField(
        controller: controller,
        keyboardType: type,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 19, color: const Color(0xFF8B867D)),
          filled: true,
          fillColor: const Color(0xFFFAF9F6),
          contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: Color(0xFFEAE6DE))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: Color(0xFFEAE6DE))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: gold, width: 1.4)),
        ),
      );

  Widget _membership(bool wide) => SingleChildScrollView(
        key: const ValueKey('membership'),
        padding: EdgeInsets.fromLTRB(wide ? 42 : 20, 26, wide ? 42 : 20, 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _backButton('Back to account', () => setState(() => view = _View.account)),
          const SizedBox(height: 20),
          const Text('Choose your membership', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900, letterSpacing: -.9)),
          const SizedBox(height: 8),
          const Text('Your account is ready. Select the level of access you want.', style: TextStyle(color: Color(0xFF77736C), fontSize: 13)),
          const SizedBox(height: 24),
          LayoutBuilder(builder: (context, constraints) {
            final horizontal = constraints.maxWidth > 620;
            final cards = [
              _planCard('ACTIVE', '₦7,000', 'A great place to start', ['Access to member experiences', 'Participate in available activities', 'Explore surveys, games and videos'], false),
              _planCard('PREMIUM', '₦14,000', 'More access. More possibilities.', ['Everything in Active', 'Premium member status', 'Access to premium experiences'], true),
            ];
            return horizontal
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: cards[0]), const SizedBox(width: 16), Expanded(child: cards[1])])
                : Column(children: [cards[0], const SizedBox(height: 15), cards[1]]);
          }),
          const SizedBox(height: 16),
          const Text('Each plan is a one-time payment. There are no monthly or recurring charges. Your membership stays Pending until payment is verified and your account is approved.', style: TextStyle(color: Color(0xFF89847B), fontSize: 11, height: 1.5)),
        ]),
      );

  Widget _planCard(String title, String price, String subtitle, List<String> benefits, bool premium) => Container(
        padding: const EdgeInsets.all(23),
        decoration: BoxDecoration(
          color: premium ? ink : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: premium ? const Color(0xFF9B762F) : const Color(0xFFE7E1D6), width: premium ? 1.4 : 1),
          boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 22, offset: Offset(0, 9))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(title, style: TextStyle(color: premium ? const Color(0xFFE4B64F) : gold, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.8)),
            const Spacer(),
            if (premium) const Icon(Icons.workspace_premium_rounded, color: Color(0xFFE4B64F), size: 21),
          ]),
          const SizedBox(height: 13),
          Text(price, style: TextStyle(color: premium ? Colors.white : ink, fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -1)),
          const SizedBox(height: 4),
          Text('ONE-TIME PAYMENT', style: TextStyle(color: premium ? const Color(0xFFE4B64F) : gold, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.4)),
          const SizedBox(height: 7),
          Text(subtitle, style: TextStyle(color: premium ? Colors.white60 : const Color(0xFF77736C), fontSize: 12)),
          const SizedBox(height: 22),
          ...benefits.map((benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.check_circle_rounded, size: 17, color: premium ? const Color(0xFFE4B64F) : gold),
                  const SizedBox(width: 9),
                  Expanded(child: Text(benefit, style: TextStyle(color: premium ? Colors.white.withValues(alpha: .86) : const Color(0xFF4F4B44), fontSize: 12, height: 1.4))),
                ]),
              )),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 49,
            child: FilledButton(
              onPressed: () => _selectPlan(title),
              style: FilledButton.styleFrom(
                backgroundColor: premium ? const Color(0xFFE0AD3E) : ink,
                foregroundColor: premium ? ink : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              ),
              child: Text('Choose $title', style: const TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ]),
      );

  Widget _account(bool wide) => SingleChildScrollView(
        key: const ValueKey('account'),
        padding: EdgeInsets.fromLTRB(wide ? 42 : 20, 28, wide ? 42 : 20, 34),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Your account', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900, letterSpacing: -.8)),
              const SizedBox(height: 8),
              const Text('Your details and membership status.', style: TextStyle(color: Color(0xFF77736C), fontSize: 13)),
              const SizedBox(height: 23),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(23),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF171511), Color(0xFF393020)]), borderRadius: BorderRadius.circular(22)),
                child: Row(children: [
                  Container(width: 54, height: 54, decoration: BoxDecoration(color: const Color(0xFFE0AD3E), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.person_rounded, color: ink, size: 28)),
                  const SizedBox(width: 15),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(accountCreated ? name : 'Welcome', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(accountCreated ? email : 'Create an account to get started', style: const TextStyle(color: Colors.white60, fontSize: 11)),
                  ])),
                  _statusPill(),
                ]),
              ),
              const SizedBox(height: 16),
              if (!accountCreated)
                _accountAction('Create your account', 'Set up your details to view membership options.', Icons.person_add_alt_1_rounded, () => setState(() => view = _View.createAccount))
              else ...[
                _detailCard('Membership', selectedPlan.isEmpty ? 'No plan selected' : selectedPlan, 'Status: $membershipStatus', Icons.workspace_premium_rounded),
                const SizedBox(height: 13),
                _detailCard('Phone number', phone, 'Account contact', Icons.phone_outlined),
                const SizedBox(height: 13),
                _detailCard('Email address', email, 'Account email', Icons.mail_outline_rounded),
                const SizedBox(height: 13),
                SizedBox(width: double.infinity, height: 50, child: OutlinedButton.icon(
                  onPressed: TelegramService.openCommunity,
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Open Telegram community'),
                  style: OutlinedButton.styleFrom(foregroundColor: ink, side: const BorderSide(color: Color(0xFFD7C9AA)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
                )),
                const SizedBox(height: 18),
                SizedBox(width: double.infinity, height: 51, child: OutlinedButton.icon(
                  onPressed: () => setState(() => view = _View.membership),
                  icon: const Icon(Icons.card_membership_rounded),
                  label: Text(selectedPlan.isEmpty ? 'Explore membership plans' : 'Change membership plan'),
                  style: OutlinedButton.styleFrom(foregroundColor: ink, side: const BorderSide(color: Color(0xFFD7C9AA)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
                )),
              ],
              const SizedBox(height: 18),
              const Text('Membership status will only change to Active or Premium after payment is securely verified.', style: TextStyle(color: Color(0xFF89847B), fontSize: 11, height: 1.5)),
            ]),
          ),
        ),
      );

  Widget _detailCard(String title, String value, String helper, IconData icon) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: const Color(0xFFECE8DF))),
        child: Row(children: [
          Icon(icon, color: gold, size: 22),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Color(0xFF77736C), fontSize: 10, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(value.isEmpty ? 'Not added' : value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(helper, style: const TextStyle(color: Color(0xFF89847B), fontSize: 10)),
          ])),
        ]),
      );

  Widget _accountAction(String title, String subtitle, IconData icon, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: const Color(0xFFECE8DF))),
          child: Row(children: [
            Icon(icon, color: gold, size: 24),
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Color(0xFF77736C), fontSize: 11)),
            ])),
            const Icon(Icons.arrow_forward_rounded, color: gold),
          ]),
        ),
      );

  Widget _backButton(String label, VoidCallback onTap) => TextButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.arrow_back_rounded, size: 17),
        label: Text(label),
        style: TextButton.styleFrom(foregroundColor: const Color(0xFF77736C), padding: EdgeInsets.zero),
      );

  Widget _bottomNav() {
    final selected = view == _View.account ? 2 : (view == _View.membership || view == _View.createAccount ? 1 : 0);
    return Container(
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFECE8DF)))),
      child: NavigationBar(
        height: 76,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedIndex: selected,
        onDestinationSelected: (index) {
          if (index == 1) {
            _exploreMembership();
          } else {
            setState(() => view = index == 0 ? _View.home : _View.account);
          }
        },
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(
            icon: _lioraNavLogo(active: selected == 1),
            label: 'Liora',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _lioraNavLogo({required bool active}) => Container(
        width: 54,
        height: 54,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(colors: [Color(0xFFFFE6A0), Color(0xFF9C6C16), Color(0xFFE8BD59)]),
          boxShadow: [
            BoxShadow(color: const Color(0xFFC58A19).withValues(alpha: active ? .48 : .28), blurRadius: active ? 24 : 16, spreadRadius: active ? 2 : 0),
            const BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 3)),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF171511)),
          padding: const EdgeInsets.all(8),
          child: ClipOval(child: Image.asset('assets/evermore_icon.png', fit: BoxFit.contain)),
        ),
      );
}
