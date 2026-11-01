import 'package:flutter/material.dart';

class LioraPlatform extends StatefulWidget {
  const LioraPlatform({super.key});
  @override
  State<LioraPlatform> createState() => _LioraPlatformState();
}

class _LioraPlatformState extends State<LioraPlatform> {
  int selected = 0;
  static const gold = Color(0xFFC58A19);
  static const ink = Color(0xFF111111);
  static const pages = ['Overview', 'Surveys', 'Games', 'Videos', 'Activities', 'Membership'];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      body: Row(children: [
        if (wide) _sidebar(),
        Expanded(child: Column(children: [
          _topbar(wide),
          Expanded(child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: wide ? 42 : 20, vertical: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: selected == 0 ? _overview(wide) : _section(wide),
            ),
          )),
          if (!wide) _bottomNav(),
        ])),
      ]),
    );
  }

  Widget _sidebar() => Container(
    width: 248, padding: const EdgeInsets.all(24), color: ink,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('LIORA', style: TextStyle(color: gold, fontSize: 27, fontWeight: FontWeight.w900, letterSpacing: 4)),
      const Text('Discover more. Become more.', style: TextStyle(color: Colors.white60, fontSize: 10)),
      const SizedBox(height: 46),
      ...List.generate(pages.length, (i) => _navItem(i)),
      const Spacer(),
      const Text('YOUR JOURNEY STARTS HERE', style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1.5)),
    ]),
  );

  Widget _navItem(int i) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: InkWell(onTap: () => setState(() => selected = i), borderRadius: BorderRadius.circular(12),
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(color: selected == i ? gold.withValues(alpha: .18) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Icon([Icons.grid_view_rounded, Icons.poll_outlined, Icons.sports_esports_outlined, Icons.play_circle_outline, Icons.bolt_outlined, Icons.workspace_premium_outlined][i], color: selected == i ? gold : Colors.white60, size: 19),
          const SizedBox(width: 12),
          Text(pages[i], style: TextStyle(color: selected == i ? Colors.white : Colors.white70, fontWeight: selected == i ? FontWeight.w700 : FontWeight.w500)),
        ])),
    ),
  );

  Widget _topbar(bool wide) => Container(
    height: 76, padding: EdgeInsets.symmetric(horizontal: wide ? 42 : 20),
    decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xFFECE8DF)))),
    child: Row(children: [
      if (!wide) const Text('LIORA', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 21, color: gold)),
      const Spacer(),
      const Icon(Icons.notifications_none_rounded, color: ink),
      const SizedBox(width: 18),
      const CircleAvatar(radius: 17, backgroundColor: Color(0xFFF1E4C9), child: Icon(Icons.person_outline, color: ink, size: 18)),
      const SizedBox(width: 9),
      if (wide) const Text('My account', style: TextStyle(fontWeight: FontWeight.w600)),
    ]),
  );

  Widget _overview(bool wide) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('WELCOME TO LIORA', style: TextStyle(color: gold, fontWeight: FontWeight.w800, letterSpacing: 2, fontSize: 11)),
    const SizedBox(height: 10),
    Text('Discover more.\nBecome more.', style: TextStyle(fontSize: wide ? 43 : 34, height: 1.12, fontWeight: FontWeight.w900, color: ink, letterSpacing: -1.5)),
    const SizedBox(height: 12),
    const Text('Your space to explore opportunities, take part and earn rewards.', style: TextStyle(color: Color(0xFF77736C), fontSize: 14)),
    const SizedBox(height: 28),
    Container(width: double.infinity, padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF171511), Color(0xFF393020)]), borderRadius: BorderRadius.circular(22)),
      child: Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, runSpacing: 18, children: [
        const SizedBox(width: 310, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('YOUR LIORA EXPERIENCE', style: TextStyle(color: gold, fontSize: 10, letterSpacing: 1.8, fontWeight: FontWeight.w800)),
          SizedBox(height: 9), Text('A little progress,\na lot of possibility.', style: TextStyle(color: Colors.white, fontSize: 25, height: 1.2, fontWeight: FontWeight.w800)),
          SizedBox(height: 8), Text('Join activities, share your opinions and discover what’s next.', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ])),
        FilledButton(onPressed: () => setState(() => selected = 5), style: FilledButton.styleFrom(backgroundColor: gold, foregroundColor: ink, padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16)), child: const Text('Explore membership')),
      ]),
    ),
    const SizedBox(height: 30),
    const Text('Explore Liora', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
    const SizedBox(height: 14),
    GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: wide ? 3 : 2, crossAxisSpacing: 13, mainAxisSpacing: 13, childAspectRatio: wide ? 1.65 : 1.15,
      children: [
        _feature(Icons.poll_outlined, 'Surveys', 'Share your views', 1),
        _feature(Icons.sports_esports_outlined, 'Games', 'Play and participate', 2),
        _feature(Icons.play_circle_outline, 'Videos', 'Watch and discover', 3),
        _feature(Icons.bolt_outlined, 'Activities', 'Take part in challenges', 4),
        _feature(Icons.workspace_premium_outlined, 'Membership', 'Choose your access', 5),
        _feature(Icons.person_outline, 'Your account', 'Manage your details', 5),
      ]),
    const SizedBox(height: 26),
    const Text('Membership plans', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
    const SizedBox(height: 14),
    Row(children: [
      Expanded(child: _plan('ACTIVE', '₦7,000', 'Access to the Liora platform')),
      const SizedBox(width: 14),
      Expanded(child: _plan('PREMIUM', '₦14,000', 'Expanded member experience')),
    ]),
    const SizedBox(height: 24),
    const Text('Rewards and earnings features are coming soon.', style: TextStyle(color: Color(0xFF77736C), fontSize: 12)),
  ]);

  Widget _feature(IconData icon, String title, String subtitle, int page) => InkWell(onTap: () => setState(() => selected = page), borderRadius: BorderRadius.circular(17),
    child: Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: const Color(0xFFECE8DF))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(icon, color: gold, size: 25),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: Color(0xFF817D75), fontSize: 11))]),
      ])),
  );

  Widget _plan(String name, String price, String desc) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: const Color(0xFFECE8DF))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(name, style: const TextStyle(color: gold, fontWeight: FontWeight.w900, letterSpacing: 1.3, fontSize: 11)),
      const SizedBox(height: 8), Text(price, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 25)),
      const SizedBox(height: 5), Text(desc, style: const TextStyle(color: Color(0xFF817D75), fontSize: 11)),
    ]),
  );

  Widget _section(bool wide) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(pages[selected], style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
    const SizedBox(height: 8),
    Text(_descriptions[selected], style: const TextStyle(color: Color(0xFF77736C))),
    const SizedBox(height: 24),
    Container(width: double.infinity, padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFECE8DF))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.hourglass_empty_rounded, color: gold, size: 30),
        const SizedBox(height: 12),
        const Text('This space is being prepared', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        const SizedBox(height: 6),
        const Text('The Liora platform experience is under development. Content and participation features will appear here when they are ready.', style: TextStyle(color: Color(0xFF77736C), height: 1.5)),
      ]),
    ),
  ]);

  String get _descriptions => [
    'Your home for everything happening on Liora.',
    'Take part in surveys and share your opinions.',
    'Explore games and interactive experiences.',
    'Discover videos and watch featured content.',
    'Find activities and opportunities to participate.',
    'Choose the membership that suits you.',
  ][selected];

  Widget _bottomNav() => NavigationBar(selectedIndex: selected < 5 ? selected : 4, onDestinationSelected: (v) => setState(() => selected = v),
    destinations: const [
      NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.poll_outlined), label: 'Surveys'),
      NavigationDestination(icon: Icon(Icons.sports_esports_outlined), label: 'Games'),
      NavigationDestination(icon: Icon(Icons.play_circle_outline), label: 'Videos'),
      NavigationDestination(icon: Icon(Icons.bolt_outlined), label: 'Activities'),
    ],
  );
}
