import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const bg = Color(0xFF0A0D18);
const panel = Color(0xFF12162A);
const cardBorder = Color(0x662A3358);
const accent = Color(0xFF4A5CF0);
const body = Color(0xFF9AA3B8);
const placeholder = Color(0xFF6B7280);
const inputBg = Color(0xFF0F1220);
const inputBorder = Color(0xFF2A2F45);
const green = Color(0xFF3ED598);
const greenBg = Color(0x331B3B2E);
const divider = Color(0xFF1C2036);

void main() => runApp(const EvermoreApp());

class EvermoreApp extends StatelessWidget {
  const EvermoreApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evermore',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.dark(primary: accent, surface: panel),
        fontFamily: 'sans',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: inputBg,
          labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          hintStyle: const TextStyle(color: placeholder),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: inputBorder)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: inputBorder)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: accent, width: 1.4)),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

TextStyle h1() => const TextStyle(fontSize: 30, height: 1.18, fontWeight: FontWeight.w800, letterSpacing: -.7, color: Colors.white);
TextStyle h2() => const TextStyle(fontSize: 23, height: 1.2, fontWeight: FontWeight.w800, letterSpacing: -.35, color: Colors.white);
TextStyle muted() => const TextStyle(fontSize: 14, height: 1.55, color: body);

class Brand extends StatelessWidget {
  final double size;
  const Brand({super.key, this.size = 21});
  @override
  Widget build(BuildContext context) => RichText(text: TextSpan(style: TextStyle(fontSize: size, fontWeight: FontWeight.w900, letterSpacing: -1), children: const [TextSpan(text: 'ever', style: TextStyle(color: Colors.white)), TextSpan(text: 'more', style: TextStyle(color: accent))]));
}

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 14, 12, 14),
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: divider))),
    child: Row(children: [const Brand(), const Spacer(), IconButton(onPressed: () => showModalBottomSheet(context: context, backgroundColor: panel, showDragHandle: true, builder: (_) => const MenuSheet()), icon: const Icon(Icons.menu_rounded))]),
  );
}

class MenuSheet extends StatelessWidget {
  const MenuSheet({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(24, 8, 24, 24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [const Brand(size: 24), const SizedBox(height: 20), ...['Features', 'Dashboard', 'App Download', 'Top Earners', 'Getting Started Guide', 'Withdrawal Info', 'Evermore Scam Alert', 'Blog', 'Terms of Service', 'Privacy Policy', 'About Evermore'].map((x) => ListTile(contentPadding: EdgeInsets.zero, title: Text(x, style: const TextStyle(fontWeight: FontWeight.w600)), onTap: () => Navigator.pop(context)))])));
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  const PrimaryButton({super.key, required this.label, this.onPressed, this.icon});
  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, height: 52, child: ElevatedButton.icon(onPressed: onPressed, icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18), label: Text(label), style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: Colors.white, elevation: 0, shadowColor: accent.withValues(alpha: .45), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))));
}

class OutlineButtonX extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  const OutlineButtonX({super.key, required this.label, this.onPressed, this.icon});
  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, height: 52, child: OutlinedButton.icon(onPressed: onPressed, icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18), label: Text(label), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: cardBorder), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))));
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const GlassCard({super.key, required this.child, this.padding = const EdgeInsets.all(22)});
  @override
  Widget build(BuildContext context) => Container(padding: padding, decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(24), border: Border.all(color: cardBorder)), child: child);
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool remember = false;
  @override
  void dispose() { email.dispose(); password.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AuthScaffold(title: 'Login to Evermore', subtitle: 'Welcome back. Continue where you left off across the Evermore ecosystem.', children: [
    const FieldLabel('Email address'),
    TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'Enter your email address')),
    const SizedBox(height: 18),
    const FieldLabel('Password'),
    TextField(controller: password, obscureText: true, decoration: const InputDecoration(hintText: 'Enter your password')),
    const SizedBox(height: 10),
    Row(children: [Checkbox(value: remember, onChanged: (v) => setState(() => remember = v ?? false), activeColor: accent, side: const BorderSide(color: inputBorder)), const Text('Remember me', style: TextStyle(color: body, fontSize: 13)), const Spacer(), TextButton(onPressed: () => _info(context, 'Password reset will be connected to the account service.'), child: const Text('Forgot password?'))]),
    const SizedBox(height: 10),
    PrimaryButton(label: 'Login', icon: Icons.arrow_forward_rounded, onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()))),
    const SizedBox(height: 20),
    Center(child: TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateAccountPage())), child: const Text('New to Evermore? Create Account'))),
  ]);
}

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});
  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}
class _CreateAccountPageState extends State<CreateAccountPage> {
  final name = TextEditingController(); final email = TextEditingController(); final phone = TextEditingController(); final password = TextEditingController(); final referral = TextEditingController();
  String country = 'Nigeria'; String package = 'Standard';
  @override
  void dispose() { name.dispose(); email.dispose(); phone.dispose(); password.dispose(); referral.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AuthScaffold(title: 'Create your account', subtitle: 'Access AI tasks, skills training, and reward opportunities across the ecosystem.', children: [
    const FieldLabel('Full name'), TextField(controller: name, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(hintText: 'Your full name')),
    const SizedBox(height: 14), const FieldLabel('Email address'), TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'you@example.com')),
    const SizedBox(height: 14), const FieldLabel('Phone number'), TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: '+234 800 000 0000')),
    const SizedBox(height: 14), const FieldLabel('Password'), TextField(controller: password, obscureText: true, decoration: const InputDecoration(hintText: 'Create a strong password')),
    const SizedBox(height: 14), const FieldLabel('Country'), DropdownButtonFormField<String>(value: country, dropdownColor: panel, decoration: const InputDecoration(), items: const [DropdownMenuItem(value: 'Nigeria', child: Text('Nigeria')), DropdownMenuItem(value: 'Ghana', child: Text('Ghana')), DropdownMenuItem(value: 'Kenya', child: Text('Kenya')), DropdownMenuItem(value: 'South Africa', child: Text('South Africa'))], onChanged: (v) => setState(() => country = v ?? country)),
    const SizedBox(height: 20), const FieldLabel('Choose your package'),
    Row(children: [Expanded(child: PackageCard(name: 'Standard', price: '₦7,000', selected: package == 'Standard', onTap: () => setState(() => package = 'Standard'))), const SizedBox(width: 12), Expanded(child: PackageCard(name: 'Premium', price: '₦14,000', selected: package == 'Premium', onTap: () => setState(() => package = 'Premium')))]),
    const SizedBox(height: 14), const FieldLabel('Referral code (optional)'), TextField(controller: referral, decoration: const InputDecoration(hintText: 'EVER-XXXX')),
    const SizedBox(height: 22), PrimaryButton(label: 'Create Account & Proceed', icon: Icons.arrow_forward_rounded, onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()))),
    const SizedBox(height: 12),
    const TrustBadge(),
    const SizedBox(height: 14),
    Center(child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Already a member? Login'))),
    const SizedBox(height: 12),
    const Text('The official Evermore website is evermoreapp.com.ng. Bookmark it and ignore lookalike links.', textAlign: TextAlign.center, style: TextStyle(color: body, fontSize: 12, height: 1.45)),
  ]);
}

class AuthScaffold extends StatelessWidget {
  final String title, subtitle; final List<Widget> children;
  const AuthScaffold({super.key, required this.title, required this.subtitle, required this.children});
  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Column(children: [const AppHeader(), Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(22, 34, 22, 38), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: h1()), const SizedBox(height: 10), Text(subtitle, style: muted()), const SizedBox(height: 28), ...children])))]));
}
class FieldLabel extends StatelessWidget { final String text; const FieldLabel(this.text, {super.key}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))); }
class TrustBadge extends StatelessWidget { const TrustBadge({super.key}); @override Widget build(BuildContext context) => Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(color: greenBg, borderRadius: BorderRadius.circular(30)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.verified_rounded, color: green, size: 16), SizedBox(width: 6), Text('CAC verified · RC 7930828', style: TextStyle(color: green, fontSize: 12, fontWeight: FontWeight.w700))]))); }
class PackageCard extends StatelessWidget { final String name, price; final bool selected; final VoidCallback onTap; const PackageCard({super.key, required this.name, required this.price, required this.selected, required this.onTap}); @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: inputBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: selected ? accent : inputBorder, width: selected ? 1.4 : 1)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded, color: selected ? accent : Colors.white, size: 20), const SizedBox(height: 12), Text(name, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(price, style: const TextStyle(color: green, fontWeight: FontWeight.w800))]))); }

class HomePage extends StatefulWidget { const HomePage({super.key}); @override State<HomePage> createState() => _HomePageState(); }
class _HomePageState extends State<HomePage> {
  int tab = 0;
  final products = const [
    ('CORE PRODUCT', 'EverAI', 'Train and evaluate AI responses through verified human feedback.', Icons.auto_awesome_rounded),
    ('LEARN', 'Evermore Academy', 'Build high-income and practical skills for your next opportunity.', Icons.school_rounded),
    ('EARN', 'Click n Earn', 'Complete available micro tasks and submit them for verification.', Icons.ads_click_rounded),
    ('EARN', 'EverMusic', 'Review music and participate in available engagement tasks.', Icons.graphic_eq_rounded),
    ('ENGAGE', 'BBNaija Predictions', 'Explore prediction and engagement opportunities across the ecosystem.', Icons.sports_esports_rounded),
  ];
  @override Widget build(BuildContext context) {
    if (tab == 1) return const EarnPage();
    if (tab == 2) return const AcademyPage();
    if (tab == 3) return const WalletPage();
    if (tab == 4) return const ProfilePage();
    return Scaffold(body: SafeArea(child: Column(children: [const AppHeader(), Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(20, 28, 20, 30), children: [
      Text('A smarter digital ecosystem: learn, engage, earn, repeat', style: h1()), const SizedBox(height: 12),
      Text('Explore EverAI training, Evermore Academy, high-income skills and verified opportunities across the Evermore ecosystem.', style: muted()), const SizedBox(height: 18),
      Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(30), border: Border.all(color: cardBorder)), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('EVERMORE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1)), SizedBox(width: 6), Text('— Exist Beyond the Moment', style: TextStyle(color: body, fontSize: 12))])),
      const SizedBox(height: 18), PrimaryButton(label: 'Activate your account', icon: Icons.arrow_forward_rounded, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateAccountPage()))), const SizedBox(height: 10), OutlineButtonX(label: 'See how earning works', icon: Icons.play_circle_outline_rounded, onPressed: () => setState(() => tab = 1)),
      const SizedBox(height: 24), const DemoBalanceCard(), const SizedBox(height: 24), const StatsGrid(), const SizedBox(height: 38),
      Text('Everything inside the Evermore platform', style: h2()), const SizedBox(height: 8), Text('Five products, one wallet. Each one is a different way to earn on the Evermore earning platform.', style: muted()), const SizedBox(height: 18),
      ...products.map((p) => ProductCard(tag: p.$1, title: p.$2, description: p.$3, icon: p.$4)),
      const SizedBox(height: 18), const PromoCard(), const SizedBox(height: 28), const AiSection(), const SizedBox(height: 28), const EssenceSection(), const SizedBox(height: 28), const FaqSection(), const SizedBox(height: 35), const Footer(),
    ]))])), bottomNavigationBar: BottomNavigationBar(currentIndex: tab, onTap: (v) => setState(() => tab = v), type: BottomNavigationBarType.fixed, backgroundColor: panel, selectedItemColor: accent, unselectedItemColor: body, items: const [BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Home'), BottomNavigationBarItem(icon: Icon(Icons.bolt_outlined), activeIcon: Icon(Icons.bolt_rounded), label: 'Earn'), BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school_rounded), label: 'Learn'), BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet_rounded), label: 'Wallet'), BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Profile')]);
  }
}

class DemoBalanceCard extends StatelessWidget { const DemoBalanceCard({super.key}); @override Widget build(BuildContext context) => GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('AVAILABLE BALANCE', style: TextStyle(color: body, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)), const SizedBox(height: 8), const Text(r'$1,248.50', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)), const SizedBox(height: 4), const Text('≈ ₦1,905,000 — sample trainer wallet', style: TextStyle(color: body, fontSize: 12)), const SizedBox(height: 5), const Text('+$0.25 credited — EverAI memory review passed', style: TextStyle(color: green, fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(height: 18), ...[('EverAI training', r'$820.00'), ('Click n Earn', r'$248.50'), ('EverMusic reviews', r'$180.00')].map((x) => Padding(padding: const EdgeInsets.only(top: 10), child: Row(children: [Expanded(child: Text(x.$1, style: const TextStyle(color: body, fontSize: 13))), Text(x.$2, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13))]))), const SizedBox(height: 14), const Text('Sample figures shown for demonstration only. Your live wallet starts from verified earnings.', style: TextStyle(color: placeholder, fontSize: 10, height: 1.4))])); }

class StatsGrid extends StatelessWidget { const StatsGrid({super.key}); @override Widget build(BuildContext context) { const stats = [('25,000+', 'Active students in Evermore Academy'), ('10,000+', 'AI response models reviewed on EverAI'), (r'$18.6', 'Peak hourly rate for AI training tasks'), ('54', 'African countries with platform access')]; return GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: stats.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 104, crossAxisSpacing: 10, mainAxisSpacing: 10), itemBuilder: (_, i) => GlassCard(padding: const EdgeInsets.all(15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(stats[i].$1, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: Colors.white)), const SizedBox(height: 5), Expanded(child: Text(stats[i].$2, style: const TextStyle(color: body, fontSize: 11, height: 1.3)))]))); } }

class ProductCard extends StatelessWidget { final String tag, title, description; final IconData icon; const ProductCard({super.key, required this.tag, required this.title, required this.description, required this.icon}); @override Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(24), border: Border.all(color: cardBorder)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: accent.withValues(alpha: .12), borderRadius: BorderRadius.circular(30)), child: Text(tag, style: const TextStyle(color: accent, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: .8)), const SizedBox(height: 14), Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: inputBg, borderRadius: BorderRadius.circular(13), border: Border.all(color: cardBorder)), child: Icon(icon, color: Colors.white, size: 21)), const SizedBox(width: 12), Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)))]), const SizedBox(height: 11), Text(description, style: muted()), const SizedBox(height: 12), const Text('Learn more →', style: TextStyle(color: accent, fontWeight: FontWeight.w800, fontSize: 13))])); }

class PromoCard extends StatelessWidget { const PromoCard({super.key}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(colors: [panel, Color(0xFF191E39)], begin: Alignment.topLeft, end: Alignment.bottomRight), border: Border.all(color: cardBorder)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('EverAI Does More!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)), const SizedBox(height: 8), const Text('Earn Up To $18.6/Hour Doing Simple Remote Tasks.', style: TextStyle(color: body, fontSize: 14, height: 1.45)), const SizedBox(height: 18), SizedBox(width: 150, child: PrimaryButton(label: 'Join us now', icon: Icons.arrow_forward_rounded, onPressed: () {}))])); }

class AiSection extends StatelessWidget { const AiSection({super.key}); @override Widget build(BuildContext context) => GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('AI is not as smart as you think', style: h2()), const SizedBox(height: 10), Text('EverAI turns human judgment into useful training data for smarter AI systems.', style: muted()), const SizedBox(height: 16), ...['No wrong answers when you follow the task guidance', 'No special skills required to get started', 'Availability across Nigeria and Africa', 'Personal mentor support', 'USD and NGN wallet withdrawals'].map((x) => Padding(padding: const EdgeInsets.only(bottom: 11), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.check_circle_rounded, color: green, size: 18), const SizedBox(width: 9), Expanded(child: Text(x, style: const TextStyle(color: body, fontSize: 13, height: 1.4)))]))), const SizedBox(height: 7), PrimaryButton(label: 'Join Evermore now', icon: Icons.arrow_forward_rounded, onPressed: () {})])); }
class EssenceSection extends StatelessWidget { const EssenceSection({super.key}); @override Widget build(BuildContext context) => GlassCard(child: Column(children: [const Text('THE ESSENCE', style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)), const SizedBox(height: 13), Text('We are the interface between possibilities and experiences. Connecting imagination to reality.', textAlign: TextAlign.center, style: h2()), const SizedBox(height: 15), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(color: inputBg, borderRadius: BorderRadius.circular(30), border: Border.all(color: cardBorder)), child: const Text('Coming soon', style: TextStyle(color: body, fontSize: 12, fontWeight: FontWeight.w700)))])); }

class FaqSection extends StatelessWidget { const FaqSection({super.key}); final questions = const ['What is Evermore?', 'Is Evermore legit or a scam?', 'What is the real Evermore website link?', 'How much can I earn on Evermore?', 'Do I need skills or experience to start?']; @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Frequently asked about Evermore', style: h2()), const SizedBox(height: 14), ...questions.map((q) => ExpansionTile(tilePadding: const EdgeInsets.symmetric(horizontal: 4), childrenPadding: const EdgeInsets.fromLTRB(4, 0, 4, 14), shape: const Border(bottom: BorderSide(color: divider)), collapsedShape: const Border(bottom: BorderSide(color: divider)), title: Text(q, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)), iconColor: accent, collapsedIconColor: body, children: [Text('Learn more about Evermore, its products and how verified opportunities work through the official platform.', style: muted())]))]); }

class Footer extends StatelessWidget { const Footer({super.key}); @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Divider(color: divider), const SizedBox(height: 25), const Brand(size: 24), const SizedBox(height: 8), const Text('💙  Exist Beyond the Moment', style: TextStyle(color: body, fontWeight: FontWeight.w600)), const SizedBox(height: 8), const Text('A smarter digital ecosystem built around learning, engagement and verified opportunities.', style: TextStyle(color: body, fontSize: 13, height: 1.5)), const SizedBox(height: 22), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [FooterCol(title: 'PLATFORM', links: const ['Features', 'Dashboard', 'App Download', 'Top Earners']), FooterCol(title: 'SUPPORT', links: const ['Getting Started Guide', 'Withdrawal Info', 'Evermore Scam Alert', 'Blog']), FooterCol(title: 'LEGAL', links: const ['Terms of Service', 'Privacy Policy', 'About Evermore'])]), const SizedBox(height: 25), const Divider(color: divider), const SizedBox(height: 14), const Text('© Evermore. All rights reserved.', style: TextStyle(color: placeholder, fontSize: 11)), const SizedBox(height: 5), const Text('evermoreapp.com.ng', style: TextStyle(color: accent, fontSize: 12, fontWeight: FontWeight.w700))]); }
class FooterCol extends StatelessWidget { final String title; final List<String> links; const FooterCol({super.key, required this.title, required this.links}); @override Widget build(BuildContext context) => SizedBox(width: 104, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: .7)), const SizedBox(height: 8), ...links.map((x) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(x, style: const TextStyle(color: body, fontSize: 10, height: 1.25))) ])); }

class EarnPage extends StatelessWidget { const EarnPage({super.key}); @override Widget build(BuildContext context) => SimplePage(title: 'Earn', subtitle: 'Verified opportunities across the Evermore ecosystem.', child: Column(children: [for (final p in const [('EverAI', 'CORE PRODUCT', Icons.auto_awesome_rounded), ('Click n Earn', 'EARN', Icons.ads_click_rounded), ('EverMusic', 'EARN', Icons.graphic_eq_rounded), ('BBNaija Predictions', 'ENGAGE', Icons.sports_esports_rounded)]) Padding(padding: const EdgeInsets.only(bottom: 12), child: GlassCard(child: Row(children: [Icon(p.$3, color: accent, size: 28), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.$1, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(p.$2, style: const TextStyle(color: accent, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: .7)), const SizedBox(height: 5), const Text('No live opportunities yet. Complete and verify tasks before earnings are credited.', style: TextStyle(color: body, fontSize: 12, height: 1.35))]))])), const SizedBox(height: 4), const Text('No unlock fee is required to access or withdraw verified earnings.', style: TextStyle(color: green, fontSize: 12, fontWeight: FontWeight.w700))])); }
class AcademyPage extends StatelessWidget { const AcademyPage({super.key}); @override Widget build(BuildContext context) => SimplePage(title: 'Evermore Academy', subtitle: 'Learn practical skills and keep building your progress.', child: Column(children: [for (final x in const [('Digital Skills', Icons.computer_rounded), ('Financial Literacy', Icons.account_balance_rounded), ('Career Growth', Icons.trending_up_rounded), ('Communication', Icons.forum_outlined)]) Padding(padding: const EdgeInsets.only(bottom: 12), child: GlassCard(child: Row(children: [Icon(x.$2, color: accent), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(x.$1, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)), const SizedBox(height: 5), const Text('Course content and lessons will appear here.', style: TextStyle(color: body, fontSize: 12)), const SizedBox(height: 10), const Text('Progress 0%', style: TextStyle(color: body, fontSize: 11))]))]))])); }
class WalletPage extends StatelessWidget { const WalletPage({super.key}); @override Widget build(BuildContext context) => SimplePage(title: 'Wallet', subtitle: 'Track verified earnings and withdrawal activity.', child: Column(children: [GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('AVAILABLE BALANCE', style: TextStyle(color: body, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)), const SizedBox(height: 7), const Text('₦0.00', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)), const SizedBox(height: 5), const Text('No verified earnings yet.', style: TextStyle(color: body, fontSize: 12)), const SizedBox(height: 18), PrimaryButton(label: 'Withdraw', icon: Icons.arrow_upward_rounded, onPressed: () => _info(context, 'Withdrawals become available when verified earnings are credited. No unlock fee is required.'))])), const SizedBox(height: 15), GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('TRANSACTIONS', style: TextStyle(color: body, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)), const SizedBox(height: 12), const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Text('No transactions yet.', style: TextStyle(color: body))))]))])); }
class ProfilePage extends StatelessWidget { const ProfilePage({super.key}); @override Widget build(BuildContext context) => SimplePage(title: 'Profile', subtitle: 'Manage your Evermore account.', child: Column(children: [GlassCard(child: const Row(children: [CircleAvatar(radius: 26, backgroundColor: accent, child: Icon(Icons.person_rounded, color: Colors.white)), SizedBox(width: 14), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Evermore Member', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)), SizedBox(height: 4), Text('Account details', style: TextStyle(color: body, fontSize: 12))])])), const SizedBox(height: 12), for (final x in const [('Bank account', Icons.account_balance_outlined), ('Referral & rewards', Icons.card_giftcard_outlined), ('Community', Icons.send_outlined), ('Help & support', Icons.help_outline_rounded), ('Settings', Icons.settings_outlined)]) Padding(padding: const EdgeInsets.only(bottom: 10), child: GlassCard(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17), child: Row(children: [Icon(x.$2, color: body), const SizedBox(width: 13), Expanded(child: Text(x.$1, style: const TextStyle(fontWeight: FontWeight.w700))), const Icon(Icons.chevron_right_rounded, color: body)])))])); }
class SimplePage extends StatelessWidget { final String title, subtitle; final Widget child; const SimplePage({super.key, required this.title, required this.subtitle, required this.child}); @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Column(children: [const AppHeader(), Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 28, 20, 30), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: h1()), const SizedBox(height: 8), Text(subtitle, style: muted()), const SizedBox(height: 24), child]))])), bottomNavigationBar: BottomNavigationBar(currentIndex: title == 'Earn' ? 1 : title == 'Evermore Academy' ? 2 : title == 'Wallet' ? 3 : 4, onTap: (i) { if (i == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage())); if (i == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const EarnPage())); if (i == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AcademyPage())); if (i == 3) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WalletPage())); if (i == 4) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfilePage())); }, type: BottomNavigationBarType.fixed, backgroundColor: panel, selectedItemColor: accent, unselectedItemColor: body, items: const [BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'), BottomNavigationBarItem(icon: Icon(Icons.bolt_outlined), label: 'Earn'), BottomNavigationBarItem(icon: Icon(Icons.school_outlined), label: 'Learn'), BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'), BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile')]) ); }

Future<void> _info(BuildContext context, String text) async { if (!context.mounted) return; showDialog(context: context, builder: (_) => AlertDialog(backgroundColor: panel, title: const Text('Evermore'), content: Text(text, style: muted()), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))])); }

class CommunityPage extends StatelessWidget { const CommunityPage({super.key}); @override Widget build(BuildContext context) => SimplePage(title: 'Join the Evermore community', subtitle: 'Get updates, guidance and community support.', child: Column(children: [const GlassCard(child: Column(children: [Icon(Icons.send_rounded, color: accent, size: 42), SizedBox(height: 15), Text('Join us now', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)), SizedBox(height: 8), Text('Connect with the Evermore community on Telegram. You can skip this and continue using the app.', textAlign: TextAlign.center, style: TextStyle(color: body, fontSize: 13, height: 1.45))])), const SizedBox(height: 15), PrimaryButton(label: 'Join us now', icon: Icons.send_rounded, onPressed: () async { final uri = Uri.parse('https://t.me/earnpalnet'); if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication); }), const SizedBox(height: 10), OutlineButtonX(label: 'Skip for now', onPressed: () => Navigator.pop(context))])); }
