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
    final screens = [
      HomeScreen(onActivate: registered ? null : _activate),
      const CourseCatalogScreen(),
      const CommunityScreen(),
      const AccountProfileScreen(),
    ];

    return Scaffold(
      body: screens[index],
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
