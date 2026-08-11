import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/evermore_theme.dart';

class EvermoreBackground extends StatelessWidget {
  final Widget child;
  const EvermoreBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: EvermoreTheme.background),
        Positioned(
          top: -90,
          right: -70,
          child: _Glow(size: 220, color: EvermoreTheme.primary.withValues(alpha: .075)),
        ),
        Positioned(
          top: 330,
          left: -120,
          child: _Glow(size: 240, color: EvermoreTheme.violet.withValues(alpha: .045)),
        ),
        child,
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  final double size;
  final Color color;
  const _Glow({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 42, sigmaY: 42),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
