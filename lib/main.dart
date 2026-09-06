import 'package:flutter/material.dart';
import 'app/app_shell.dart';
import 'core/theme/evermore_theme.dart';

void main() => runApp(const EvermoreApp());

class EvermoreApp extends StatelessWidget {
  const EvermoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evermore',
      theme: EvermoreTheme.theme(),
      home: const AppShell(),
    );
  }
}
