import 'package:flutter/material.dart';

/// Liora logo mark (gold icon), shown at any size.
class LioraMark extends StatelessWidget {
  final double size;
  final Color? color; // kept for compatibility, unused
  const LioraMark({super.key, this.size = 28, this.color});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(size * .22),
        child: Image.asset('assets/evermore_icon.png',
            width: size, height: size, fit: BoxFit.cover),
      );
}
