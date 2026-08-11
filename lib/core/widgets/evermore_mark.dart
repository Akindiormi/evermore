import 'package:flutter/material.dart';
import '../theme/evermore_theme.dart';

/// Lightweight vector version of the Evermore growth/infinity mark.
/// Kept in code so the brand can be used without shipping a raster asset.
class EvermoreMark extends StatelessWidget {
  final double size;
  final Color? color;

  const EvermoreMark({super.key, this.size = 28, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _EvermoreMarkPainter(color ?? EvermoreTheme.primary),
    );
  }
}

class _EvermoreMarkPainter extends CustomPainter {
  final Color color;
  _EvermoreMarkPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * .13
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(scale * .34, scale * .54)
      ..cubicTo(scale * .18, scale * .30, scale * .02, scale * .40, scale * .13, scale * .67)
      ..cubicTo(scale * .22, scale * .88, scale * .45, scale * .77, scale * .58, scale * .57)
      ..lineTo(scale * .79, scale * .31);

    canvas.drawPath(path, paint);

    final rightLoop = Path()
      ..moveTo(scale * .63, scale * .57)
      ..cubicTo(scale * .77, scale * .36, scale * .95, scale * .43, scale * .86, scale * .67)
      ..cubicTo(scale * .78, scale * .86, scale * .58, scale * .76, scale * .48, scale * .64);
    canvas.drawPath(rightLoop, paint);

    final arrow = Path()
      ..moveTo(scale * .69, scale * .30)
      ..lineTo(scale * .86, scale * .16)
      ..lineTo(scale * .82, scale * .39);
    canvas.drawPath(arrow, paint);
  }

  @override
  bool shouldRepaint(covariant _EvermoreMarkPainter oldDelegate) => oldDelegate.color != color;
}
