import 'package:flutter/material.dart';
import '../core/theme/evermore_theme.dart';

/// A bold, outlined pill button with a solid offset "shadow" layer behind
/// it — presses down to meet the shadow on tap for a tactile feel.
class NeoPillButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color fillColor;
  final Color shadowColor;
  final Color textColor;
  final IconData? icon;
  final bool fullWidth;
  final EdgeInsets padding;

  const NeoPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fillColor = EvermoreTheme.primary,
    this.shadowColor = EvermoreTheme.primaryLight,
    this.textColor = Colors.white,
    this.icon,
    this.fullWidth = true,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
  });

  @override
  State<NeoPillButton> createState() => _NeoPillButtonState();
}

class _NeoPillButtonState extends State<NeoPillButton> {
  bool pressed = false;

  static const _offset = 5.0;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    final fill = disabled ? EvermoreTheme.muted.withValues(alpha: .35) : widget.fillColor;
    final shadow = disabled ? EvermoreTheme.muted.withValues(alpha: .18) : widget.shadowColor;

    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => pressed = true),
      onTapUp: disabled ? null : (_) => setState(() => pressed = false),
      onTapCancel: disabled ? null : () => setState(() => pressed = false),
      onTap: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.only(right: _offset, bottom: _offset),
        child: Stack(
          children: [
            // Offset shadow layer
            Positioned(
              right: -_offset,
              bottom: -_offset,
              left: 0,
              top: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: shadow,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            // Front pill — shifts down/right on press to meet the shadow layer
            AnimatedContainer(
              duration: const Duration(milliseconds: 90),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(pressed ? _offset : 0, pressed ? _offset : 0, 0),
              width: widget.fullWidth ? double.infinity : null,
              padding: widget.padding,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: EvermoreTheme.ink, width: 2.2),
              ),
              child: Row(
                mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: widget.textColor, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: TextStyle(color: widget.textColor, fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
