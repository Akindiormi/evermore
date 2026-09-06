import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

const everBlue = Color(0xFF01339E);
const everBlue2 = Color(0xFF2366E8);
const everInk = Color(0xFF10213F);
const everMuted = Color(0xFF6D7890);
const everSurface = Color(0xFFF6F8FC);

void main() => runApp(const EvermoreApp());

void push(BuildContext context, Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));
void replace(BuildContext context, Widget page) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
void message(BuildContext context, String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

class EvermoreApp extends StatelessWidget {
  const EvermoreApp({super.key});
  @override
  Widget build(BuildContext context) {
    final fonts = GoogleFonts.manropeTextTheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evermore',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: everBlue, brightness: Brightness.light),
        textTheme: fonts.apply(bodyColor: everInk, displayColor: everInk),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: everSurface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: everBlue, width: 1.4)),
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
        width: size,
        height: size,
        padding: EdgeInsets.all(size * .22),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [everBlue, everBlue2]), borderRadius: BorderRadius.circular(size * .28)),
        child: Image.asset('assets/evermore_icon.png', fit: BoxFit.contain),
      );
}

class AppButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool outlined;
  const AppButton({super.key, required this.label, required this.icon, required this.onTap, this.outlined = false});
  @override
  Widget build(BuildContext context) {
    final child = Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(width: 9), Icon(icon, size: 19)]);
    return SizedBox(width: double.infinity, height: 54, child: outlined ? OutlinedButton(onPressed: onTap, child: child) : FilledButton(onPressed: onTap, child: child));
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const BrandMark(size: 56),
              const Spacer(),
              Text('learn. engage.\nearn more.', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1.5)),
              const SizedBox(height: 18),
              Text('A smarter digital ecosystem for learning practical skills, completing verified opportunities and building your progress.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: everMuted, height: 1.5)),
              const SizedBox(height: 34),
              AppButton(label: 'Get started', icon: Icons.arrow_forward_rounded, onTap: () => push(context, const SignUpScreen())),
              const SizedBox(height: 12),
              AppButton(label: 'Log in', icon: Icons.login_rounded, outlined: true, onTap: () => push(context, const LoginScreen())),
              const SizedBox(height: 18),
              Center(child: Text('Built around the Evermore ecosystem', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: everMuted))),
            ]),
          ),
        ),
      );
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override State<SignUpScreen> createState() => _SignUpState();
}
class _SignUpState extends State<SignUpScreen> {
  final name = TextEditingController(), email = TextEditingController(), password = TextEditingController(), confirm = TextEditingController(), referral = TextEditingController();
  bool obscure = true;
  @override void dispose() { name.dispose(); email.dispose(); password.dispose(); confirm.dispose(); referral.dispose(); super.dispose(); }
  void next() {
    if (name.text.trim().isEmpty || email.text.trim().isEmpty || password.text.isEmpty || password.text != confirm.text) {
      message(context, 'Please complete your details and make sure your passwords match.');
      return;
    }
    replace(context, InterestScreen(name: name.text.trim()));
  }
  @override
  Widget build(BuildContext context) => AuthLayout(title: 'Create your account', subtitle: 'Start your Evermore journey with a few simple details.', children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline_rounded))),
        const SizedBox(height: 12),
        TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.mail_outline_rounded))),
        const SizedBox(height: 12),
        TextField(controller: password, obscureText: obscure, decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline_rounded), suffixIcon: IconButton(onPressed: () => setState(() => obscure = !obscure), icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined)))),
        const SizedBox(height: 12),
        TextField(controller: confirm, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm password', prefixIcon: Icon(Icons.verified_user_outlined))),
        const SizedBox(height: 12),
        TextField(controller: referral, decoration: const InputDecoration(labelText: 'Referral code (optional)', prefixIcon: Icon(Icons.card_giftcard_outlined))),
        const SizedBox(height: 22),
        AppButton(label: 'Create account', icon: Icons.arrow_forward_rounded, onTap: next),
        const SizedBox(height: 14),
        const Center(child: Text('No phone number or OTP required.', style: TextStyle(color: everMuted))),
      ]);
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginState();
}
class _LoginState extends State<LoginScreen> {
  final email = TextEditingController(), password = TextEditingController();
  @override void dispose() { email.dispose(); password.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AuthLayout(title: 'Welcome back', subtitle: 'Log in to continue your Evermore journey.', children: [
        TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.mail_outline_rounded))),
        const SizedBox(height: 12),
        TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline_rounded))),
        Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => message(context, 'Password reset will be connected to the account service.'), child: const Text('Forgot password?'))),
        AppButton(label: 'Log in', icon: Icons.login_rounded, onTap: () => replace(context, const MainShell(userName: 'Akin'))),
      ]);
}

class AuthLayout extends StatelessWidget {
  final String title, subtitle;
  final List<Widget> children;
  const AuthLayout({super.key, required this.title, required this.subtitle, required this.children});
  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)),
        const SizedBox(height: 14),
        const BrandMark(),
        const SizedBox(height: 24),
        Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(subtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: everMuted)),
        const SizedBox(height: 24),
        ...children,
      ]))));
}

class InterestScreen extends StatefulWidget {
  final String name;
  const InterestScreen({super.key, required this.name});
  @override State<InterestScreen> createState() => _InterestState();
}
class _InterestState extends State<InterestScreen> {
  final selected = <String>{};
  final items = const [('AI training', Icons.auto_awesome_outlined), ('micro tasks', Icons.ads_click_rounded), ('music reviews', Icons.graphic_eq_rounded), ('learning', Icons.school_outlined)];
  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const BrandMark(),
        const SizedBox(height: 26),
        Text('what do you want to explore?', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('Pick what interests you. You can change this later.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: everMuted)),
        const SizedBox(height: 22),
        ...items.map((x) => Padding(padding: const EdgeInsets.only(bottom: 10), child: ChoiceTile(title: x.$1, icon: x.$2, selected: selected.contains(x.$1), onTap: () => setState(() => selected.contains(x.$1) ? selected.remove(x.$1) : selected.add(x.$1)))),
        const Spacer(),
        AppButton(label: 'Continue', icon: Icons.arrow_forward_rounded, onTap: () => replace(context, CommunityScreen(name: widget.name))),
        Center(child: TextButton(onPressed: () => replace(context, CommunityScreen(name: widget.name)), child: const Text('Skip personalization'))),
      ]))));
}

class CommunityScreen extends StatelessWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});
  Future<void> join() async {
    final uri = Uri.parse('https://t.me/earnpalnet');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
        const Spacer(),
        const BrandMark(size: 80),
        const SizedBox(height: 24),
        const Text('join the Evermore community', textAlign: TextAlign.center, style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        const Text('Get guidance on tasks, learn how Evermore works, stay updated and connect with the community on Telegram.', textAlign: TextAlign.center, style: TextStyle(color: everMuted, height: 1.5)),
        const Spacer(),
        AppButton(label: 'Join community', icon: Icons.send_rounded, onTap: join),
        TextButton(onPressed: () => replace(context, MainShell(userName: name)), child: const Text('Skip for now')),
      ]))));
}

enum Product { ai, click, music, predictions }
String productName(Product p) => switch (p) { Product.ai => 'EverAI', Product.click => 'Click n Earn', Product.music => 'EverMusic', Product.predictions => 'BBNaija Predictions' };
String productText(Product p) => switch (p) { Product.ai => 'Train and evaluate AI responses through verified human feedback tasks.', Product.click => 'Complete available micro tasks carefully and submit them for verification.', Product.music => 'Review music and complete engagement tasks when opportunities are available.', Product.predictions => 'Explore prediction content and available engagement opportunities.' };
IconData productIcon(Product p) => switch (p) { Product.ai => Icons.auto_awesome_rounded, Product.click => Icons.ads_click_rounded, Product.music => Icons.graphic_eq_rounded, Product.predictions => Icons.emoji_events_rounded };

class MainShell extends StatefulWidget {
  final String userName;
  const MainShell({super.key, this.userName = 'Akin'});
  @override State<MainShell> createState() => _ShellState();
}
class _ShellState extends State<MainShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [Home(name: widget.userName), const Earn(), const Learn(), const Wallet(), const Profile()];
    return Scaffold(body: IndexedStack(index: index, children: pages), bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (v) => setState(() => index = v), destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.bolt_outlined), selectedIcon: Icon(Icons.bolt_rounded), label: 'Earn'),
      NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book_rounded), label: 'Learn'),
      NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet_rounded), label: 'Wallet'),
      NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
    ]));
  }
}

class Home extends StatelessWidget {
  final String name;
  const Home({super.key, this.name = 'Akin'});
  @override
  Widget build(BuildContext context) => PageLayout(title: 'good morning, ${name.split(' ').first}', subtitle: 'ready to make progress today?', children: [
        const BalanceCard(),
        ProductCard(product: Product.ai), ProductCard(product: Product.click), ProductCard(product: Product.music), ProductCard(product: Product.predictions),
        const InfoCard(title: 'Evermore Academy', text: 'Learn practical digital, financial, career and communication skills.', icon: Icons.school_outlined),
        const InfoCard(title: 'community', text: 'Ask questions and stay updated with Evermore.', icon: Icons.forum_outlined),
      ]);
}
class Earn extends StatelessWidget {
  const Earn({super.key});
  @override
  Widget build(BuildContext context) => PageLayout(title: 'earn with Evermore', subtitle: 'Complete verified opportunities and build your balance.', children: [
        ProductCard(product: Product.ai), ProductCard(product: Product.click), ProductCard(product: Product.music), ProductCard(product: Product.predictions),
        const InfoCard(title: 'verified earnings', text: 'Only completed and verified tasks are credited. There is no fee or unlock payment required to access approved earnings.', icon: Icons.verified_outlined),
      ]);
}
class Learn extends StatelessWidget {
  const Learn({super.key});
  @override
  Widget build(BuildContext context) => PageLayout(title: 'Evermore Academy', subtitle: 'Learn practical skills at your own pace.', children: const [
        CourseCard(title: 'Digital Skills', icon: Icons.laptop_mac_outlined), CourseCard(title: 'Financial Literacy', icon: Icons.account_balance_outlined), CourseCard(title: 'Career Growth', icon: Icons.trending_up_rounded), CourseCard(title: 'Communication', icon: Icons.forum_outlined),
      ]);
}
class Wallet extends StatelessWidget {
  const Wallet({super.key});
  @override
  Widget build(BuildContext context) => PageLayout(title: 'wallet', subtitle: 'Track earnings and manage withdrawals.', children: const [
        BalanceCard(), InfoCard(title: 'no transactions yet', text: 'Your verified earnings and withdrawals will appear here.', icon: Icons.receipt_long_outlined), InfoCard(title: 'secure withdrawals', text: 'Add bank details when ready. Approved earnings should never require an unlock fee.', icon: Icons.security_outlined),
      ]);
}
class Profile extends StatelessWidget {
  const Profile({super.key});
  @override
  Widget build(BuildContext context) => PageLayout(title: 'profile', subtitle: 'Manage your Evermore account.', children: [
        const InfoCard(title: 'Your Evermore account', text: 'Complete details when needed.', icon: Icons.person_outline_rounded),
        MenuRow(title: 'Bank account', icon: Icons.account_balance_outlined, onTap: () => showBankDialog(context)),
        const MenuRow(title: 'Referral & rewards', icon: Icons.card_giftcard_outlined),
        MenuRow(title: 'Evermore community', icon: Icons.forum_outlined, onTap: () => openCommunity()),
        const MenuRow(title: 'Help & support', icon: Icons.help_outline_rounded),
        const MenuRow(title: 'Settings', icon: Icons.settings_outlined),
      ]);
}

class PageLayout extends StatelessWidget {
  final String title, subtitle;
  final List<Widget> children;
  const PageLayout({super.key, required this.title, required this.subtitle, required this.children});
  @override
  Widget build(BuildContext context) => SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 32), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6), Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: everMuted)),
        const SizedBox(height: 22), ...children.map((w) => Padding(padding: const EdgeInsets.only(bottom: 12), child: w)),
      ]));
}

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});
  @override
  Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(colors: [everBlue, everBlue2]), borderRadius: BorderRadius.circular(26)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('available balance', style: TextStyle(color: Colors.white70)), const SizedBox(height: 8), const Text('₦0.00', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)), const SizedBox(height: 16),
        FilledButton.tonalIcon(onPressed: () => showWithdrawDialog(context), icon: const Icon(Icons.south_west_rounded), label: const Text('Withdraw')),
      ]);
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});
  @override
  Widget build(BuildContext context) => InkWell(onTap: () => push(context, ProductDetail(product: product)), borderRadius: BorderRadius.circular(20), child: Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: everSurface, borderRadius: BorderRadius.circular(20)), child: Row(children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: Icon(productIcon(product), color: everBlue)),
        const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(productName(product), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)), const SizedBox(height: 3), Text(productText(product), style: const TextStyle(color: everMuted))])),
        const Icon(Icons.chevron_right_rounded, color: everBlue),
      ])));
}

class ProductDetail extends StatelessWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});
  @override
  Widget build(BuildContext context) => PageLayout(title: productName(product), subtitle: productText(product), children: const [
        StepCard(), InfoCard(title: 'No live opportunities yet', text: 'When verified opportunities are available they will appear here. Earnings are credited only after completion and verification.', icon: Icons.task_alt_rounded),
      ]);
}
class StepCard extends StatelessWidget {
  const StepCard({super.key});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: everSurface, borderRadius: BorderRadius.circular(20)), child: const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        StepItem(icon: Icons.touch_app_outlined, label: 'task'), StepItem(icon: Icons.verified_outlined, label: 'verify'), StepItem(icon: Icons.account_balance_wallet_outlined, label: 'withdraw'),
      ]);
}
class StepItem extends StatelessWidget {
  final IconData icon; final String label;
  const StepItem({super.key, required this.icon, required this.label});
  @override Widget build(BuildContext context) => Column(children: [Icon(icon, color: everBlue), const SizedBox(height: 7), Text(label, style: const TextStyle(fontWeight: FontWeight.w700))]);
}
class InfoCard extends StatelessWidget {
  final String title, text; final IconData icon;
  const InfoCard({super.key, required this.title, required this.text, required this.icon});
  @override Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: everSurface, borderRadius: BorderRadius.circular(20)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: everBlue), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 5), Text(text, style: const TextStyle(color: everMuted, height: 1.45))])),
      ]));
}
class CourseCard extends StatelessWidget {
  final String title; final IconData icon;
  const CourseCard({super.key, required this.title, required this.icon});
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: everSurface, borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, color: everBlue), const SizedBox(width: 12), Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16))]), const SizedBox(height: 15), const LinearProgressIndicator(value: 0), const SizedBox(height: 7), const Text('0% complete', style: TextStyle(color: everMuted)),
      ]);
}
class ChoiceTile extends StatelessWidget {
  final String title; final IconData icon; final bool selected; final VoidCallback onTap;
  const ChoiceTile({super.key, required this.title, required this.icon, required this.selected, required this.onTap});
  @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: selected ? everBlue.withValues(alpha: .08) : everSurface, borderRadius: BorderRadius.circular(18), border: Border.all(color: selected ? everBlue : Colors.transparent)), child: Row(children: [Icon(icon, color: everBlue), const SizedBox(width: 14), Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))), Icon(selected ? Icons.check_circle_rounded : Icons.circle_outlined, color: everBlue)])));
}
class MenuRow extends StatelessWidget {
  final String title; final IconData icon; final VoidCallback? onTap;
  const MenuRow({super.key, required this.title, required this.icon, this.onTap});
  @override Widget build(BuildContext context) => ListTile(onTap: onTap, tileColor: everSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), leading: Icon(icon, color: everBlue), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), trailing: const Icon(Icons.chevron_right_rounded));
}

Future<void> openCommunity() async {
  final uri = Uri.parse('https://t.me/earnpalnet');
  if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
}

void showBankDialog(BuildContext context) {
  final bank = TextEditingController(); final account = TextEditingController();
  showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Bank account'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: bank, decoration: const InputDecoration(labelText: 'Bank name')), const SizedBox(height: 12), TextField(controller: account, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Account number'))]), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Save'))]));
}

void showWithdrawDialog(BuildContext context) => showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Withdraw'), content: const Text('Your available balance is ₦0.00. Approved earnings can be withdrawn without any unlock or access fee.'), actions: [FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Done'))]));
