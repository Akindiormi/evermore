import 'package:flutter/material.dart';
import 'core/theme/evermore_theme.dart';
import 'services/progress_service.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/learn/learn_screen.dart';
import 'screens/community/community_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'widgets/evermore_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EvermoreApp());
}

class EvermoreApp extends StatelessWidget {
  const EvermoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evermore',
      debugShowCheckedModeBanner: false,
      theme: EvermoreTheme.theme(),
      home: const AppGate(),
    );
  }
}

class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  bool? onboarded;

  @override
  void initState() {
    super.initState();
    ProgressService().hasCompletedOnboarding().then((value) {
      if (mounted) setState(() => onboarded = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (onboarded == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return onboarded!
        ? const MainShell()
        : OnboardingScreen(onComplete: () {
            setState(() => onboarded = true);
          });
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  final screens = const [
    HomeScreen(),
    LearnScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: EvermoreNavigation(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
      ),
    );
  }
}
