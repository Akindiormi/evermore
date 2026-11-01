import 'package:flutter/material.dart';
import 'app/liora_platform.dart';
import 'core/theme/evermore_theme.dart';

void main() => runApp(const LioraApp());

class LioraApp extends StatelessWidget {
  const LioraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Liora',
      theme: LioraTheme.theme(),
      home: const LioraPlatform(),
    );
  }
}
