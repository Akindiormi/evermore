import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

const everBlue = Color(0xFF01339E);
const everInk = Color(0xFF10213F);
const everMuted = Color(0xFF6D7890);
const everSurface = Color(0xFFF6F8FC);

void main() => runApp(const EvermoreApp());

class EvermoreApp extends StatelessWidget {
  const EvermoreApp({super.key});
  @override
  Widget build(BuildContext context) {
    final base = GoogleFonts.manropeTextTheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evermore',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: everBlue, brightness: Brightness.light),
        textTheme: base.apply(bodyColor: everInk, displayColor: everInk),
        inputDecorationTheme: InputDecorationTheme(
          filled: true, fillColor: everSurface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: everBlue, width: 1.4)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class BrandMark extends StatelessWidget {
  final double size;
  const BrandMark({super.key, this.size = 48});
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [everBlue, Color(0xFF2366E8)]),
      borderRadius: BorderRadius.circular(size * .28),
      boxShadow: [BoxShadow(color: everBlue.withOpacity(.18), blurRadius: 24, offset: const Offset(0, 10))],
    ),
    padding: EdgeInsets.all(size * .22),
    child: Image.asset('assets/evermore_icon.png', fit: BoxFit.contain),
  );
}

class SoftBackground extends StatelessWidget {
  final Widget child;
  const SoftBackground({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Stack(children: [
    Positioned(top: -90, right: -80, child: _orb(220, const Color(0xFFE8F0FF))),
    Positioned(bottom: 80, left: -120, child: _orb(250, const Color(0xFFF1F5FF))),
    child,
  ]);
  Widget _orb(double size, Color color) => Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: SoftBackground(child: SafeArea(child: Padding(
    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const BrandMark(size: 56), const Spacer(),
      Text('learn. engage.\nearn more.', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, height: .98, letterSpacing: -1.5)),
      const SizedBox(height: 18),
      Text('A smarter digital ecosystem for learning practical skills, completing verified opportunities and building your progress.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: everMuted, height: 1.55)),
      const SizedBox(height: 34),
      _PrimaryButton(label: 'Get started', icon: Icons.arrow_forward_rounded, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen()))),
      const SizedBox(height: 12),
      _SecondaryButton(label: 'Log in', icon: Icons.login_rounded, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()))),
      const SizedBox(height: 18),
      Center(child: Text('Built around the Evermore ecosystem', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: everMuted))),
    ]),
  ))));
}

class SignUpScreen extends StatefulWidget { const SignUpScreen({super.key}); @override State<SignUpScreen> createState() => _SignUpScreenState(); }
class _SignUpScreenState extends State<SignUpScreen> {
  final name = TextEditingController(), email = TextEditingController(), password = TextEditingController(), confirm = TextEditingController(), referral = TextEditingController();
  bool obscure = true;
  @override void dispose() { name.dispose(); email.dispose(); password.dispose(); confirm.dispose(); referral.dispose(); super.dispose(); }
  void next() {
    if (name.text.trim().isEmpty || email.text.trim().isEmpty || password.text.isEmpty || password.text != confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete your details and make sure your passwords match.'))); return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => InterestScreen(name: name.text.trim())));
  }
  @override Widget build(BuildContext context) => _AuthScaffold(title: 'Create your account', subtitle: 'Start your Evermore journey with a few simple details.', children: [
    TextField(controller: name, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline_rounded))),
    const SizedBox(height: 14), TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.mail_outline_rounded))),
    const SizedBox(height: 14), TextField(controller: password, obscureText: obscure, decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline_rounded), suffixIcon: IconButton(onPressed: () => setState(() => obscure = !obscure), icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined)))),
    const SizedBox(height: 14), TextField(controller: confirm, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm password', prefixIcon: Icon(Icons.verified_user_outlined))),
    const SizedBox(height: 14), TextField(controller: referral, decoration: const InputDecoration(labelText: 'Referral code (optional)', prefixIcon: Icon(Icons.card_giftcard_outlined))),
    const SizedBox(height: 24), _PrimaryButton(label: 'Create account', icon: Icons.arrow_forward_rounded, onTap: next),
    const SizedBox(height: 16), Center(child: Text('No phone number or OTP required.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: everMuted))),
  ]);
}

class LoginScreen extends StatefulWidget { const LoginScreen({super.key}); @override State<LoginScreen> createState() => _LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController(), password = TextEditingController();
  @override void dispose() { email.dispose(); password.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => _AuthScaffold(title: 'Welcome back', subtitle: 'Log in to continue your Evermore journey.', children: [
    TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.mail_outline_rounded))),
    const SizedBox(height: 14), TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline_rounded))),
    Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => _message(context, 'Password reset will be connected to the account service.'), child: const Text('Forgot password?'))),
    const SizedBox(height: 10), _PrimaryButton(label: 'Log in', icon: Icons.login_rounded, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell(userName: 'Akin')))),
  ]);
}

class _AuthScaffold extends StatelessWidget {
  final String title, subtitle; final List<Widget> children;
  const _AuthScaffold({required this.title, required this.subtitle, required this.children});
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(24, 22, 24, 30), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)), const SizedBox(height: 18), const BrandMark(size: 50), const SizedBox(height: 28),
    Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -.7)), const SizedBox(height: 9),
    Text(subtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: everMuted, height: 1.5)), const SizedBox(height: 28), ...children,
  ])));
}

class InterestScreen extends StatefulWidget { final String name; const InterestScreen({super.key, required this.name}); @override State<InterestScreen> createState() => _InterestScreenState(); }
class _InterestScreenState extends State<InterestScreen> {
  final selected = <String>{};
  final items = const [('AI training', Icons.auto_awesome_outlined), ('micro tasks', Icons.ads_click_rounded), ('music reviews', Icons.graphic_eq_rounded), ('learning', Icons.school_outlined)];
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 14), const BrandMark(size: 50), const SizedBox(height: 28),
    Text('what do you want to explore?', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -.7)), const SizedBox(height: 9),
    Text('Pick what interests you. You can change this later.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: everMuted)), const SizedBox(height: 24),
    ...items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _ChoiceTile(title: item.$1, icon: item.$2, selected: selected.contains(item.$1), onTap: () => setState(() => selected.contains(item.$1) ? selected.remove(item.$1) : selected.add(item.$1)))),
    const Spacer(), _PrimaryButton(label: 'Continue', icon: Icons.arrow_forward_rounded, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CommunityIntroScreen(name: widget.name)))),
    Center(child: TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CommunityIntroScreen(name: widget.name))), child: const Text('Skip personalization')),
  ])));
}

class CommunityIntroScreen extends StatelessWidget {
  final String name;
  const CommunityIntroScreen({super.key, this.name = 'Akin'});
  Future<void> _join() async { final uri = Uri.parse('https://t.me/earnpalnet'); if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication); }
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Spacer(), Center(child: Container(width: 92, height: 92, decoration: const BoxDecoration(color: Color(0xFFEAF1FF), shape: BoxShape.circle), child: Icon(Icons.forum_outlined, size: 42, color: everBlue))), const SizedBox(height: 28),
    Text('join the Evermore community', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 14),
    Text('Get guidance on tasks, learn how Evermore works, stay updated and connect with the community on Telegram.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: everMuted, height: 1.55)), const SizedBox(height: 16),
    const _InfoCard(icon: Icons.info_outline_rounded, title: 'recommended, not required', text: 'You can skip Telegram and still use Evermore.'), const Spacer(),
    _PrimaryButton(label: 'Join community', icon: Icons.send_rounded, onTap: _join), const SizedBox(height: 10), Center(child: TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainShell(userName: name))), child: const Text('Skip for now'))),
  ])));
}

class MainShell extends StatefulWidget { final String userName; const MainShell({super.key, this.userName = 'Akin'}); @override State<MainShell> createState() => _MainShellState(); }
class _MainShellState extends State<MainShell> {
  int index = 0;
  @override Widget build(BuildContext context) {
    final screens = [HomeScreen(userName: widget.userName), const EarnScreen(), const LearnScreen(), const WalletScreen(), const ProfileScreen()];
    return Scaffold(body: IndexedStack(index: index, children: screens), bottomNavigationBar: NavigationBar(height: 76, selectedIndex: index, onDestinationSelected: (v) => setState(() => index = v), destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.bolt_outlined), selectedIcon: Icon(Icons.bolt_rounded), label: 'Earn'),
      NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book_rounded), label: 'Learn'),
      NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet_rounded), label: 'Wallet'),
      NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
    ]));
  }
}

class HomeScreen extends StatelessWidget {
  final String userName; const HomeScreen({super.key, this.userName = 'Akin'});
  @override Widget build(BuildContext context) => _Page(padding: const EdgeInsets.fromLTRB(20, 20, 20, 28), children: [
    Row(children: [const BrandMark(size: 42), const Spacer(), _CircleIcon(icon: Icons.notifications_none_rounded, onTap: () {})]), const SizedBox(height: 26),
    Text('good morning, ${userName.split(' ').first}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -.5)), const SizedBox(height: 5),
    Text('ready to make progress today?', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: everMuted)), const SizedBox(height: 20), const _WalletCard(), const SizedBox(height: 26),
    _SectionHeader(title: 'earn with Evermore', action: 'view all', onTap: () {}), const SizedBox(height: 12),
    Row(children: [Expanded(child: _ProductCard(title: 'EverAI', subtitle: 'Train AI with verified tasks', icon: Icons.auto_awesome_outlined, onTap: () => _open(context, const ProductDetailScreen(type: ProductType.ai)))), const SizedBox(width: 12), Expanded(child: _ProductCard(title: 'Click n Earn', subtitle: 'Complete simple tasks', icon: Icons.ads_click_rounded, onTap: () => _open(context, const ProductDetailScreen(type: ProductType.click))))]),
    const SizedBox(height: 12), _ProductWideCard(title: 'EverMusic', subtitle: 'Review and engage with music', icon: Icons.graphic_eq_rounded, onTap: () => _open(context, const ProductDetailScreen(type: ProductType.music))), const SizedBox(height: 12),
    _ProductWideCard(title: 'BBNaija Predictions', subtitle: 'Follow predictions and engagement opportunities', icon: Icons.emoji_events_outlined, onTap: () => _open(context, const ProductDetailScreen(type: ProductType.predictions))),
    const SizedBox(height: 26), _SectionHeader(title: 'learn with Evermore', action: 'open academy', onTap: () {}), const SizedBox(height: 12), const _AcademyCard(), const SizedBox(height: 22), const _CommunityBanner(),
  ]);
}

enum ProductType { ai, click, music, predictions }

class ProductDetailScreen extends StatelessWidget {
  final ProductType type; const ProductDetailScreen({super.key, required this.type});
  String get title => switch (type) { ProductType.ai => 'EverAI', ProductType.click => 'Click n Earn', ProductType.music => 'EverMusic', ProductType.predictions => 'BBNaija Predictions' };
  String get description => switch (type) { ProductType.ai => 'Train and evaluate AI responses through verified human feedback tasks.', ProductType.click => 'Complete available micro tasks carefully and submit them for verification.', ProductType.music => 'Review music and complete engagement tasks when opportunities are available.', ProductType.predictions => 'Explore prediction content and available engagement opportunities.' };
  IconData get icon => switch (type) { ProductType.ai => Icons.auto_awesome_rounded, ProductType.click => Icons.ads_click_rounded, ProductType.music => Icons.graphic_eq_rounded, ProductType.predictions => Icons.emoji_events_rounded };
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: _Page(padding: const EdgeInsets.fromLTRB(20, 14, 20, 30), children: [
    Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)), const Spacer(), const BrandMark(size: 40)]), const SizedBox(height: 18),
    Container(width: 66, height: 66, decoration: BoxDecoration(color: const Color(0xFFEAF1FF), borderRadius: BorderRadius.circular(20)), child: Icon(icon, color: everBlue, size: 34)), const SizedBox(height: 20),
    Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 9), Text(description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: everMuted, height: 1.5)), const SizedBox(height: 24),
    const _FlowCard(), const SizedBox(height: 22), const _EmptyState(icon: Icons.task_alt_rounded, title: 'No live opportunities yet', text: 'When verified opportunities are available, they will appear here. Earnings are credited only after completion and verification.'), const SizedBox(height: 18),
    const _InfoCard(icon: Icons.verified_outlined, title: 'how it works', text: 'Choose a task, complete it carefully, submit it for verification, then receive the approved reward in your wallet.'),
  ])));
}

class EarnScreen extends StatelessWidget { const EarnScreen({super.key}); @override Widget build(BuildContext context) => _Page(title: 'earn with Evermore', subtitle: 'Complete verified opportunities and build your balance.', children: [
  _ProductWideCard(title: 'EverAI', subtitle: 'Train and evaluate AI responses.', icon: Icons.auto_awesome_outlined, onTap: () => _open(context, const ProductDetailScreen(type: ProductType.ai))),
  const SizedBox(height: 12), _ProductWideCard(title: 'Click n Earn', subtitle: 'Complete available micro tasks.', icon: Icons.ads_click_rounded, onTap: () => _open(context, const ProductDetailScreen(type: ProductType.click))),
  const SizedBox(height: 12), _ProductWideCard(title: 'EverMusic', subtitle: 'Review and engage with music.', icon: Icons.graphic_eq_rounded, onTap: () => _open(context, const ProductDetailScreen(type: ProductType.music))),
  const SizedBox(height: 12), _ProductWideCard(title: 'BBNaija Predictions', subtitle: 'Explore prediction and engagement opportunities.', icon: Icons.emoji_events_outlined, onTap: () => _open(context, const ProductDetailScreen(type: ProductType.predictions))),
  const SizedBox(height: 24), const _InfoCard(icon: Icons.verified_outlined, title: 'verified earnings', text: 'Only completed and verified tasks are credited to your Evermore wallet. There is no fee or unlock payment required to access your own approved earnings.'),
]); }

class LearnScreen extends StatelessWidget { const LearnScreen({super.key}); @override Widget build(BuildContext context) => _Page(title: 'Evermore Academy', subtitle: 'Learn practical skills at your own pace.', children: [
  const _CourseCard(title: 'Digital Skills', progress: 0, icon: Icons.laptop_mac_outlined), const SizedBox(height: 12), const _CourseCard(title: 'Financial Literacy', progress: 0, icon: Icons.account_balance_outlined), const SizedBox(height: 12), const _CourseCard(title: 'Career Growth', progress: 0, icon: Icons.trending_up_rounded), const SizedBox(height: 12), const _CourseCard(title: 'Communication', progress: 0, icon: Icons.forum_outlined), const SizedBox(height: 24),
  const _InfoCard(icon: Icons.auto_graph_rounded, title: 'your progress', text: 'Courses, lessons, XP, streaks and achievements will live here as you learn.'),
]); }

class WalletScreen extends StatelessWidget { const WalletScreen({super.key}); @override Widget build(BuildContext context) => _Page(title: 'wallet', subtitle: 'Track earnings and manage withdrawals.', children: [
  const _WalletCard(), const SizedBox(height: 26), _SectionHeader(title: 'recent activity', action: 'see all', onTap: () {}), const SizedBox(height: 12), const _EmptyState(icon: Icons.receipt_long_outlined, title: 'No transactions yet', text: 'Your verified earnings and withdrawals will appear here.'), const SizedBox(height: 18),
  const _InfoCard(icon: Icons.security_outlined, title: 'secure withdrawals', text: 'Add your bank details when you are ready to make your first withdrawal. Approved earnings should never require an unlock fee.'),
]); }

class ProfileScreen extends StatelessWidget { const ProfileScreen({super.key}); @override Widget build(BuildContext context) => _Page(title: 'profile', subtitle: 'Manage your Evermore account.', children: [
  Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: everSurface, borderRadius: BorderRadius.circular(24)), child: const Row(children: [CircleAvatar(radius: 28, backgroundColor: everBlue, child: Icon(Icons.person_rounded, color: Colors.white, size: 28)), SizedBox(width: 14), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Your Evermore account', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)), SizedBox(height: 4), Text('Complete details when needed', style: TextStyle(color: everMuted))])])), const SizedBox(height: 20),
  _MenuTile(icon: Icons.account_circle_outlined, title: 'Account details', onTap: () {}), _MenuTile(icon: Icons.account_balance_outlined, title: 'Bank account', onTap: () => _showBank(context)), _MenuTile(icon: Icons.card_giftcard_outlined, title: 'Referral & rewards', onTap: () {}), _MenuTile(icon: Icons.forum_outlined, title: 'Evermore community', onTap: () => _joinCommunity()), _MenuTile(icon: Icons.help_outline_rounded, title: 'Help & support', onTap: () {}), _MenuTile(icon: Icons.settings_outlined, title: 'Settings', onTap: () {}),
]); }

class _WalletCard extends StatelessWidget { const _WalletCard(); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [everBlue, Color(0xFF1558CF)]), borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: everBlue.withOpacity(.2), blurRadius: 28, offset: const Offset(0, 14))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  Row(children: [Text('available balance', style: TextStyle(color: Colors.white.withOpacity(.72))), const Spacer(), Icon(Icons.account_balance_wallet_outlined, color: Colors.white.withOpacity(.9))]), const SizedBox(height: 10), const Text('₦0.00', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1)), const SizedBox(height: 3), Text('≈ \$0.00', style: TextStyle(color: Colors.white.withOpacity(.7))), const SizedBox(height: 20),
  Row(children: [Expanded(child: _WalletAction(label: 'Withdraw', icon: Icons.south_west_rounded, onTap: () => _showWithdraw(context))), const SizedBox(width: 10), Expanded(child: _WalletAction(label: 'History', icon: Icons.receipt_long_outlined, light: true, onTap: () {}))])
])); }

class _WalletAction extends StatelessWidget { final String label; final IconData icon; final bool light; final VoidCallback onTap; const _WalletAction({required this.label, required this.icon, required this.onTap, this.light = false}); @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14), child: Container(height: 46, decoration: BoxDecoration(color: light ? Colors.white.withOpacity(.12) : Colors.white, borderRadius: BorderRadius.circular(14)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 18, color: light ? Colors.white : everBlue), const SizedBox(width: 7), Text(label, style: TextStyle(fontWeight: FontWeight.w700, color: light ? Colors.white : everBlue))]))); }

class _ProductCard extends StatelessWidget { final String title, subtitle; final IconData icon; final VoidCallback onTap; const _ProductCard({required this.title, required this.subtitle, required this.icon, required this.onTap}); @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(24), child: Container(height: 174, padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE9EDF5)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.035), blurRadius: 18, offset: const Offset(0, 8))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFEAF1FF), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: everBlue)), const Spacer(), Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(subtitle, maxLines: 2, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: everMuted, height: 1.35))]))); }

class _ProductWideCard extends StatelessWidget { final String title, subtitle; final IconData icon; final VoidCallback onTap; const _ProductWideCard({required this.title, required this.subtitle, required this.icon, required this.onTap}); @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(22), child: Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: everSurface, borderRadius: BorderRadius.circular(22)), child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: everBlue)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: everMuted))])), const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: everMuted)]))); }

class _AcademyCard extends StatelessWidget { const _AcademyCard(); @override Widget build(BuildContext context) => InkWell(onTap: () {}, borderRadius: BorderRadius.circular(24), child: Container(padding: const EdgeInsets.all(19), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFF0F5FF), Colors.white]), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE3EAF8))), child: Row(children: [Container(width: 54, height: 54, decoration: BoxDecoration(color: everBlue, borderRadius: BorderRadius.circular(17)), child: const Icon(Icons.school_outlined, color: Colors.white)), const SizedBox(width: 14), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Evermore Academy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)), SizedBox(height: 4), Text('Build practical skills and track your progress.', style: TextStyle(color: everMuted, height: 1.3))])), const Icon(Icons.chevron_right_rounded, color: everBlue)]))); }

class _CommunityBanner extends StatelessWidget { const _CommunityBanner(); @override Widget build(BuildContext context) => InkWell(onTap: _joinCommunity, borderRadius: BorderRadius.circular(24), child: Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: everInk, borderRadius: BorderRadius.circular(24)), child: Row(children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white.withOpacity(.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.forum_outlined, color: Colors.white)), const SizedBox(width: 13), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Need help?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)), SizedBox(height: 3), Text('Ask the Evermore community.', style: TextStyle(color: Color(0xFFB9C3D8))])), const Icon(Icons.arrow_forward_rounded, color: Colors.white)]))); }

class _CourseCard extends StatelessWidget { final String title; final double progress; final IconData icon; const _CourseCard({required this.title, required this.progress, required this.icon}); @override Widget build(BuildContext context) => InkWell(onTap: () {}, borderRadius: BorderRadius.circular(22), child: Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFE8ECF4))), child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFEAF1FF), borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: everBlue)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 10), LinearProgressIndicator(value: progress, minHeight: 5, borderRadius: BorderRadius.circular(8), backgroundColor: const Color(0xFFE9EDF5), color: everBlue)])), const SizedBox(width: 12), const Icon(Icons.chevron_right_rounded, color: everMuted)]))); }

class _FlowCard extends StatelessWidget { const _FlowCard(); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: everSurface, borderRadius: BorderRadius.circular(22)), child: const Row(children: [Expanded(child: _FlowStep(icon: Icons.touch_app_outlined, title: 'task')), Expanded(child: _FlowStep(icon: Icons.verified_outlined, title: 'verify')), Expanded(child: _FlowStep(icon: Icons.account_balance_wallet_outlined, title: 'withdraw'))])); }
class _FlowStep extends StatelessWidget { final IconData icon; final String title; const _FlowStep({required this.icon, required this.title}); @override Widget build(BuildContext context) => Column(children: [Icon(icon, color: everBlue), const SizedBox(height: 7), Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))]); }
class _InfoCard extends StatelessWidget { final IconData icon; final String title, text; const _InfoCard({required this.icon, required this.title, required this.text}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFFF4F7FC), borderRadius: BorderRadius.circular(22)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: everBlue), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 5), Text(text, style: const TextStyle(color: everMuted, height: 1.45))]))])); }
class _EmptyState extends StatelessWidget { final IconData icon; final String title, text; const _EmptyState({required this.icon, required this.title, required this.text}); @override Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(26), decoration: BoxDecoration(color: everSurface, borderRadius: BorderRadius.circular(22)), child: Column(children: [Icon(icon, size: 32, color: everMuted), const SizedBox(height: 10), Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 5), Text(text, textAlign: TextAlign.center, style: const TextStyle(color: everMuted, height: 1.4))])); }
class _MenuTile extends StatelessWidget { final IconData icon; final String title; final VoidCallback onTap; const _MenuTile({required this.icon, required this.title, required this.onTap}); @override Widget build(BuildContext context) => ListTile(onTap: onTap, contentPadding: const EdgeInsets.symmetric(vertical: 4), leading: Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFEAF1FF), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: everBlue)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), trailing: const Icon(Icons.chevron_right_rounded, color: everMuted)); }
class _ChoiceTile extends StatelessWidget { final String title; final IconData icon; final bool selected; final VoidCallback onTap; const _ChoiceTile({required this.title, required this.icon, required this.selected, required this.onTap}); @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: selected ? const Color(0xFFEAF1FF) : Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: selected ? everBlue : const Color(0xFFE8ECF4), width: selected ? 1.5 : 1)), child: Row(children: [Icon(icon, color: everBlue), const SizedBox(width: 14), Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))), Icon(selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: selected ? everBlue : everMuted)]))); }
class _CircleIcon extends StatelessWidget { final IconData icon; final VoidCallback onTap; const _CircleIcon({required this.icon, required this.onTap}); @override Widget build(BuildContext context) => IconButton(onPressed: onTap, style: IconButton.styleFrom(backgroundColor: everSurface), icon: Icon(icon, color: everInk)); }
class _PrimaryButton extends StatelessWidget { final String label; final IconData icon; final VoidCallback onTap; const _PrimaryButton({required this.label, required this.icon, required this.onTap}); @override Widget build(BuildContext context) => SizedBox(width: double.infinity, height: 56, child: FilledButton.icon(onPressed: onTap, icon: Icon(icon), label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)))); }
class _SecondaryButton extends StatelessWidget { final String label; final IconData icon; final VoidCallback onTap; const _SecondaryButton({required this.label, required this.icon, required this.onTap}); @override Widget build(BuildContext context) => SizedBox(width: double.infinity, height: 56, child: OutlinedButton.icon(onPressed: onTap, icon: Icon(icon), label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)))); }
class _Page extends StatelessWidget { final String? title, subtitle; final EdgeInsets padding; final List<Widget> children; const _Page({this.title, this.subtitle, this.padding = const EdgeInsets.fromLTRB(20, 24, 20, 32), required this.children}); @override Widget build(BuildContext context) => SafeArea(child: SoftBackground(child: SingleChildScrollView(padding: padding, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [if (title != null) Text(title!, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -.8)), if (subtitle != null) ...[const SizedBox(height: 6), Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: everMuted, height: 1.45))], if (title != null) const SizedBox(height: 24), ...children])))); }
class _SectionHeader extends StatelessWidget { final String title, action; final VoidCallback onTap; const _SectionHeader({required this.title, required this.action, required this.onTap}); @override Widget build(BuildContext context) => Row(children: [Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)), const Spacer(), TextButton(onPressed: onTap, child: Text(action))]); }

void _open(BuildContext context, Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));
void _message(BuildContext context, String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
Future<void> _joinCommunity() async { final uri = Uri.parse('https://t.me/earnpalnet'); if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication); }
void _showWithdraw(BuildContext context) => showModalBottomSheet(context: context, showDragHandle: true, builder: (_) => const Padding(padding: EdgeInsets.fromLTRB(22, 8, 22, 30), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('withdrawal', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)), SizedBox(height: 8), Text('Your available balance is ₦0.00. Add bank details and complete verified tasks before requesting a withdrawal.', style: TextStyle(color: everMuted, height: 1.5)), SizedBox(height: 18), _InfoCard(icon: Icons.security_outlined, title: 'no unlock fee', text: 'Approved earnings should be withdrawable without paying a fee to unlock them.')])));
void _showBank(BuildContext context) => showModalBottomSheet(context: context, isScrollControlled: true, showDragHandle: true, builder: (_) => Padding(padding: EdgeInsets.fromLTRB(22, 8, 22, MediaQuery.of(context).viewInsets.bottom + 28), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('bank account', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('You can set this up when you are ready for your first withdrawal.', style: TextStyle(color: everMuted)), const SizedBox(height: 18), const TextField(decoration: InputDecoration(labelText: 'Bank name', prefixIcon: Icon(Icons.account_balance_outlined))), const SizedBox(height: 12), const TextField(keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Account number', prefixIcon: Icon(Icons.numbers_rounded))), const SizedBox(height: 16), _PrimaryButton(label: 'Save bank details', icon: Icons.check_rounded, onTap: () => Navigator.pop(context))]));
