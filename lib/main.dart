import 'package:flutter/material.dart';
import 'app/app_shell.dart';
import 'core/theme/evermore_theme.dart';

void main() => runApp(const ForgeXApp());

class ForgeXApp extends StatelessWidget {
  const ForgeXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ForgeX',
      theme: ForgeXTheme.theme(),
      home: const AppShell(),
    );
  }
}
