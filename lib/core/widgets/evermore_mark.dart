import 'package:flutter/material.dart';

/// ForgeX logo mark (the F icon), shown at any size.
class ForgeXMark extends StatelessWidget {
  final double size;
  final Color? color; // kept for compatibility, unused
  const ForgeXMark({super.key, this.size = 28, this.color});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(size * .22),
        child: Image.asset('assets/evermore_icon.png',
            width: size, height: size, fit: BoxFit.cover),
      );
}
