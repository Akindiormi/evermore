import 'package:flutter/material.dart';
import 'core/theme/evermore_theme.dart';
import 'screens/community/community_screen.dart';
import 'screens/earn/earn_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/learn/learn_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'services/progress_service.dart';
import 'widgets/evermore_navigation.dart';

void main() => runApp(const EvermoreApp());

class EvermoreApp extends StatelessWidget {
  const EvermoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evermore',
      theme: EvermoreTheme.theme(),
      home: const AppGate(),
    );
  }
}

/// Decides whether to show onboarding or the main app shell, based on
/// whether the user has completed onboarding before (persisted locally
/// via [ProgressService]).
class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  bool? _onboarded;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final done = await ProgressService().hasCompletedOnboarding();
    if (mounted) setState(() => _onboarded = done);
  }

  @override
  Widget build(BuildContext context) {
    if (_onboarded == null) {
      return const Scaffold(
        backgroundColor: EvermoreTheme.background,
        body: Center(
          child: CircularProgressIndicator(color: EvermoreTheme.primary),
        ),
      );
    }
    if (!_onboarded!) {
      return OnboardingScreen(
        onComplete: () => setState(() => _onboarded = true),
      );
    }
    return const HomeShell();
  }
}

/// The main app shell: five tabs (Home, Learn, Earn, Community, Profile)
/// behind a floating pill navigation bar. Each screen manages its own
/// scroll/background — this shell just switches between them.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    LearnScreen(),
    EarnScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: EvermoreNavigation(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
      ),
    );
  }
}
