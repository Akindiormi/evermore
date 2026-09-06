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
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: everSurface,
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
  final bool inverse;
  const BrandMark({super.key, this.size = 48, this.inverse = false});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: inverse ? [Colors.white, const Color(0xFFDDE8FF)] : [everBlue, const Color(0xFF2366E8)]),
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
  Widget build(BuildContext context) => Scaffold(
        body: SoftBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const BrandMark(size: 56),
                const Spacer(),
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
            ),
          ),
        ),
      );
}

class SignUpScreen extends StatefulWidget { const SignUpScreen({super.key}); @override State<SignUpScreen> createState() => _SignUpScreenState(); }
class _SignUpScreenState extends State<SignUpScreen> {
  final name = TextEditingController(), email = TextEditingController(), password = TextEditingController(), referral = TextEditingController();
  bool obscure = true;
  @override Widget build(BuildContext context) => _AuthScaffold(title: 'Create your account', subtitle: 'Start your Evermore journey with a few simple details.', children: [
    TextField(controller: name, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline_rounded))),
    const SizedBox(height: 14),
    TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.mail_outline_rounded))),
    const SizedBox(height: 14),
    TextField(controller: password, obscureText: obscure, decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline_rounded), suffixIcon: IconButton(onPressed: () => setState(() => obscure = !obscure), icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined)))),
    const SizedBox(height: 14),
    TextField(controller: referral, decoration: const InputDecoration(labelText: 'Referral code (optional)', prefixIcon: Icon(Icons.card_giftcard_outlined))),
    const SizedBox(height: 24),
    _PrimaryButton(label: 'Create account', icon: Icons.arrow_forward_rounded, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CommunityIntroScreen()))),
    const SizedBox(height: 16),
    Center(child: Text('By continuing, you agree to Evermore’s terms and privacy policy.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: everMuted, height: 1.4))),
  ]);
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override Widget build(BuildContext context) => _AuthScaffold(title: 'Welcome back', subtitle: 'Log in to continue your Evermore journey.', children: [
    const TextField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.mail_outline_rounded))),
    const SizedBox(height: 14),
    const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline_rounded))),
    const SizedBox(height: 10),
    Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text('Forgot password?'))),
    const SizedBox(height: 10),
    _PrimaryButton(label: 'Log in', icon: Icons.login_rounded, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell()))),
  ]);
}

class _AuthScaffold extends StatelessWidget {
  final String title, subtitle; final List<Widget> children;
  const _AuthScaffold({required this.title, required this.subtitle, required this.children});
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(24, 22, 24, 30), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)), const SizedBox(height: 18),
    const BrandMark(size: 50), const SizedBox(height: 28),
    Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -.7)),
    const SizedBox(height: 9), Text(subtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: everMuted, height: 1.5)),
    const SizedBox(height: 28), ...children,
  ])));
}

class CommunityIntroScreen extends StatelessWidget {
  const CommunityIntroScreen({super.key});
  Future<void> _join() async { final uri = Uri.parse('https://t.me/evermorecommunity'); if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication); }
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Spacer(), Center(child: Container(width: 92, height: 92, decoration: BoxDecoration(color: Color(0xFFEAF1FF), shape: BoxShape.circle), child: const Icon(Icons.forum_outlined, size: 42, color: everBlue))),
    const SizedBox(height: 28), Text('join the Evermore community', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
    const SizedBox(height: 14), Text('Get guidance on tasks, learn how Evermore works, stay updated and connect with the community on Telegram.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: everMuted, height: 1.55)),
    const Spacer(), _PrimaryButton(label: 'Join community', icon: Icons.send_rounded, onTap: _join), const SizedBox(height: 10),
    Center(child: TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell())), child: const Text('Skip for now'))),
  ])));
}

class MainShell extends StatefulWidget { const MainShell({super.key}); @override State<MainShell> createState() => _MainShellState(); }
class _MainShellState extends State<MainShell> {
  int index = 0;
  final screens = const [HomeScreen(), EarnScreen(), LearnScreen(), WalletScreen(), ProfileScreen()];
  final destinations = const [
    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.bolt_outlined), selectedIcon: Icon(Icons.bolt_rounded), label: 'Earn'),
    NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book_rounded), label: 'Learn'),
    NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet_rounded), label: 'Wallet'),
    NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
  ];
  @override Widget build(BuildContext context) => Scaffold(body: IndexedStack(index: index, children: screens), bottomNavigationBar: NavigationBar(height: 76, selectedIndex: index, onDestinationSelected: (v) => setState(() => index = v), destinations: destinations));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override Widget build(BuildContext context) => _Page(padding: const EdgeInsets.fromLTRB(20, 20, 20, 24), children: [
    Row(children: [const BrandMark(size: 42), const Spacer(), _CircleIcon(icon: Icons.notifications_none_rounded, onTap: () {})]),
    const SizedBox(height: 26), Text('good morning, Akin', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -.5)),
    const SizedBox(height: 5), Text('ready to make progress today?', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: everMuted)),
    const SizedBox(height: 20), const _WalletCard(),
    const SizedBox(height: 26), _SectionHeader(title: 'earn with Evermore', action: 'view all', onTap: () {}), const SizedBox(height: 12),
    Row(children: [Expanded(child: _ProductCard(title: 'EverAI', subtitle: 'Train AI with verified tasks', icon: Icons.auto_awesome_outlined)), const SizedBox(width: 12), Expanded(child: _ProductCard(title: 'Click n Earn', subtitle: 'Complete simple tasks', icon: Icons.ads_click_rounded))]),
    const SizedBox(height: 12), const _ProductWideCard(title: 'EverMusic', subtitle: 'Review and engage with music', icon: Icons.graphic_eq_rounded),
    const SizedBox(height: 26), _SectionHeader(title: 'learn with Evermore', action: 'open academy', onTap: () {}), const SizedBox(height: 12), const _AcademyCard(),
    const SizedBox(height: 22), const _CommunityBanner(),
  ]);
}

class _WalletCard extends StatelessWidget { const _WalletCard(); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [everBlue, Color(0xFF1558CF)]), borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: everBlue.withOpacity(.2), blurRadius: 28, offset: const Offset(0, 14))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text('available balance', style: TextStyle(color: Colors.white.withOpacity(.72))), const Spacer(), Icon(Icons.account_balance_wallet_outlined, color: Colors.white.withOpacity(.9))]), const SizedBox(height: 10), const Text('₦0.00', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1)), const SizedBox(height: 3), Text('≈ \$0.00', style: TextStyle(color: Colors.white.withOpacity(.7))), const SizedBox(height: 20), Row(children: [Expanded(child: _WalletAction(label: 'Withdraw', icon: Icons.south_west_rounded)), const SizedBox(width: 10), Expanded(child: _WalletAction(label: 'History', icon: Icons.receipt_long_outlined, light: true))]) ])); }
class _WalletAction extends StatelessWidget { final String label; final IconData icon; final bool light; const _WalletAction({required this.label, required this.icon, this.light = false}); @override Widget build(BuildContext context) => Container(height: 46, decoration: BoxDecoration(color: light ? Colors.white.withOpacity(.12) : Colors.white, borderRadius: BorderRadius.circular(14)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 18, color: light ? Colors.white : everBlue), const SizedBox(width: 7), Text(label, style: TextStyle(fontWeight: FontWeight.w700, color: light ? Colors.white : everBlue))])); }

class _ProductCard extends StatelessWidget { final String title, subtitle; final IconData icon; const _ProductCard({required this.title, required this.subtitle, required this.icon}); @override Widget build(BuildContext context) => Container(height: 174, padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE9EDF5)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.035), blurRadius: 18, offset: const Offset(0, 8))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFEAF1FF), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: everBlue)), const Spacer(), Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(subtitle, maxLines: 2, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: everMuted, height: 1.35))])); }
class _ProductWideCard extends StatelessWidget { final String title, subtitle; final IconData icon; const _ProductWideCard({required this.title, required this.subtitle, required this.icon}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: everSurface, borderRadius: BorderRadius.circular(22)), child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: everBlue)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: everMuted))])), const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: everMuted)])); }
class _AcademyCard extends StatelessWidget { const _AcademyCard(); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(19), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFF0F5FF), Color(0xFFFFFFFF)]), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE3EAF8))), child: Row(children: [Container(width: 54, height: 54, decoration: BoxDecoration(color: everBlue, borderRadius: BorderRadius.circular(17)), child: const Icon(Icons.school_outlined, color: Colors.white)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Evermore Academy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text('Build practical skills and track your progress.', style: TextStyle(color: everMuted, height: 1.3))])), const Icon(Icons.chevron_right_rounded, color: everBlue)])); }
class _CommunityBanner extends StatelessWidget { const _CommunityBanner(); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: everInk, borderRadius: BorderRadius.circular(24)), child: Row(children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white.withOpacity(.1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.forum_outlined, color: Colors.white)), const SizedBox(width: 13), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Need help?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)), SizedBox(height: 3), Text('Ask the Evermore community.', style: TextStyle(color: Color(0xFFB9C3D8)))])), const Icon(Icons.arrow_forward_rounded, color: Colors.white)])); }

class EarnScreen extends StatelessWidget { const EarnScreen({super.key}); @override Widget build(BuildContext context) => _Page(title: 'earn with Evermore', subtitle: 'Complete verified opportunities and build your balance.', children: [const _ProductWideCard(title: 'EverAI', subtitle: 'Train and evaluate AI responses.', icon: Icons.auto_awesome_outlined), const SizedBox(height: 12), const _ProductWideCard(title: 'Click n Earn', subtitle: 'Complete available micro tasks.', icon: Icons.ads_click_rounded), const SizedBox(height: 12), const _ProductWideCard(title: 'EverMusic', subtitle: 'Review and engage with music.', icon: Icons.graphic_eq_rounded), const SizedBox(height: 24), const _InfoCard(icon: Icons.verified_outlined, title: 'verified earnings', text: 'Only completed and verified tasks are credited to your Evermore wallet.')]); }
class LearnScreen extends StatelessWidget { const LearnScreen({super.key}); @override Widget build(BuildContext context) => _Page(title: 'Evermore Academy', subtitle: 'Learn practical skills at your own pace.', children: [const _CourseCard(title: 'Digital Skills', progress: .0, icon: Icons.laptop_mac_outlined), const SizedBox(height: 12), const _CourseCard(title: 'Financial Literacy', progress: .0, icon: Icons.account_balance_outlined), const SizedBox(height: 12), const _CourseCard(title: 'Career Growth', progress: .0, icon: Icons.trending_up_rounded), const SizedBox(height: 24), const _InfoCard(icon: Icons.auto_graph_rounded, title: 'your progress', text: 'Courses, lessons, XP, streaks and achievements will live here as you learn.')]); }
class _CourseCard extends StatelessWidget { final String title; final double progress; final IconData icon; const _CourseCard({required this.title, required this.progress, required this.icon}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFE8ECF4))), child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFEAF1FF), borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: everBlue)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 10), LinearProgressIndicator(value: progress, minHeight: 5, borderRadius: BorderRadius.circular(8), backgroundColor: const Color(0xFFE9EDF5), color: everBlue)])), const SizedBox(width: 12), const Icon(Icons.chevron_right_rounded, color: everMuted)])); }

class WalletScreen extends StatelessWidget { const WalletScreen({super.key}); @override Widget build(BuildContext context) => _Page(title: 'wallet', subtitle: 'Track earnings and manage withdrawals.', children: [const _WalletCard(), const SizedBox(height: 26), _SectionHeader(title: 'recent activity', action: 'see all', onTap: () {}), const SizedBox(height: 12), const _EmptyState(icon: Icons.receipt_long_outlined, title: 'No transactions yet', text: 'Your verified earnings and withdrawals will appear here.'), const SizedBox(height: 18), const _InfoCard(icon: Icons.security_outlined, title: 'secure withdrawals', text: 'Add your bank details when you are ready to make your first withdrawal.')]); }
class ProfileScreen extends StatelessWidget { const ProfileScreen({super.key}); @override Widget build(BuildContext context) => _Page(title: 'profile', subtitle: 'Manage your Evermore account.', children: [Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: everSurface, borderRadius: BorderRadius.circular(24)), child: const Row(children: [CircleAvatar(radius: 28, backgroundColor: everBlue, child: Icon(Icons.person_rounded, color: Colors.white, size: 28)), SizedBox(width: 14), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Akin', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)), SizedBox(height: 4), Text('Set up your profile', style: TextStyle(color: everMuted))])])), const SizedBox(height: 20), const _MenuTile(icon: Icons.account_circle_outlined, title: 'Account details'), const _MenuTile(icon: Icons.account_balance_outlined, title: 'Bank account'), const _MenuTile(icon: Icons.card_giftcard_outlined, title: 'Referral & rewards'), const _MenuTile(icon: Icons.forum_outlined, title: 'Evermore community'), const _MenuTile(icon: Icons.help_outline_rounded, title: 'Help & support'), const _MenuTile(icon: Icons.settings_outlined, title: 'Settings')]); }

class _Page extends StatelessWidget { final String? title, subtitle; final EdgeInsets padding; final List<Widget> children; const _Page({this.title, this.subtitle, this.padding = const EdgeInsets.fromLTRB(20, 24, 20, 32), required this.children}); @override Widget build(BuildContext context) => SafeArea(child: SoftBackground(child: SingleChildScrollView(padding: padding, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [if (title != null) ...[Text(title!, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -.8)), if (subtitle != null) ...[const SizedBox(height: 6), Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: everMuted, height: 1.45))], const SizedBox(height: 24)], ...children])))); }
class _SectionHeader extends StatelessWidget { final String title, action; final VoidCallback onTap; const _SectionHeader({required this.title, required this.action, required this.onTap}); @override Widget build(BuildContext context) => Row(children: [Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)), const Spacer(), TextButton(onPressed: onTap, child: Text(action))]); }
class _InfoCard extends StatelessWidget { final IconData icon; final String title, text; const _InfoCard({required this.icon, required this.title, required this.text}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFFF4F7FC), borderRadius: BorderRadius.circular(22)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: everBlue), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 5), Text(text, style: const TextStyle(color: everMuted, height: 1.45))]))])); }
class _EmptyState extends StatelessWidget { final IconData icon; final String title, text; const _EmptyState({required this.icon, required this.title, required this.text}); @override Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(26), decoration: BoxDecoration(color: everSurface, borderRadius: BorderRadius.circular(22)), child: Column(children: [Icon(icon, size: 32, color: everMuted), const SizedBox(height: 10), Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 5), Text(text, textAlign: TextAlign.center, style: const TextStyle(color: everMuted, height: 1.4))])); }
class _MenuTile extends StatelessWidget { final IconData icon; final String title; const _MenuTile({required this.icon, required this.title}); @override Widget build(BuildContext context) => ListTile(contentPadding: const EdgeInsets.symmetric(vertical: 4), leading: Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFEAF1FF), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: everBlue)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), trailing: const Icon(Icons.chevron_right_rounded, color: everMuted)); }
class _CircleIcon extends StatelessWidget { final IconData icon; final VoidCallback onTap; const _CircleIcon({required this.icon, required this.onTap}); @override Widget build(BuildContext context) => IconButton(onPressed: onTap, style: IconButton.styleFrom(backgroundColor: everSurface), icon: Icon(icon, color: everInk)); }
class _PrimaryButton extends StatelessWidget { final String label; final IconData icon; final VoidCallback onTap; const _PrimaryButton({required this.label, required this.icon, required this.onTap}); @override Widget build(BuildContext context) => SizedBox(width: double.infinity, height: 56, child: FilledButton.icon(onPressed: onTap, icon: Icon(icon), label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)))); }
class _SecondaryButton extends StatelessWidget { final String label; final IconData icon; final VoidCallback onTap; const _SecondaryButton({required this.label, required this.icon, required this.onTap}); @override Widget build(BuildContext context) => SizedBox(width: double.infinity, height: 56, child: OutlinedButton.icon(onPressed: onTap, icon: Icon(icon), label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)))); }
