import 'package:flutter/material.dart';
import '../core/theme/evermore_theme.dart';
import '../services/account_service.dart';
import '../screens/home/home_screen.dart';
import '../screens/community/community_screen.dart';
import '../screens/profile/account_profile_screen.dart';
import '../screens/account/registration_screen.dart';
import '../screens/courses/course_catalog_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;
  bool registered = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final value = await AccountService().isRegistered();
    if (mounted) setState(() => registered = value);
  }

  Future<void> _activate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegistrationScreen()),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final home = HomeScreen();
    final screens = [
      home,
      const CourseCatalogScreen(),
      const CommunityScreen(),
      const AccountProfileScreen(),
    ];

    return Scaffold(
      body: index == 0 && !registered
          ? Column(
              children: [
                const Expanded(child: HomeScreen()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: ActivationPrompt(onTap: _activate),
                ),
              ],
            )
          : screens[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        backgroundColor: Colors.white.withValues(alpha: .94),
        elevation: 0,
        indicatorColor: EvermoreTheme.primaryLight,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups_rounded),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class ActivationPrompt extends StatelessWidget {
  final VoidCallback onTap;

  const ActivationPrompt({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: EvermoreTheme.glassCard(
            radius: 20,
            color: Colors.white.withValues(alpha: .82),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: EvermoreTheme.softGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person_add_alt_1_rounded,
                  color: EvermoreTheme.primary,
                  size: 19,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready to activate?',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Create your account and continue to payment.',
                      style: TextStyle(color: EvermoreTheme.muted, fontSize: 9.5),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: EvermoreTheme.primary,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
