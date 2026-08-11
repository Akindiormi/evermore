import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/evermore_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    final fill = disabled ? EvermoreTheme.muted.withValues(alpha: .22) : widget.fillColor;
    final shadow = disabled ? Colors.transparent : widget.shadowColor.withValues(alpha: .65);

    return GestureDetector(
      onTapDown: disabled ? null : (_) {
        HapticFeedback.selectionClick();
        setState(() => pressed = true);
      },
      onTapUp: disabled ? null : (_) => setState(() => pressed = false),
      onTapCancel: disabled ? null : () => setState(() => pressed = false),
      onTap: disabled ? null : widget.onPressed,
      child: AnimatedScale(
        scale: pressed ? .975 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: Container(
          width: widget.fullWidth ? double.infinity : null,
          padding: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(color: shadow, borderRadius: BorderRadius.circular(19)),
          child: Container(
            width: widget.fullWidth ? double.infinity : null,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: Colors.white.withValues(alpha: .22)),
              boxShadow: disabled ? const [] : [BoxShadow(color: EvermoreTheme.primary.withValues(alpha: .20), blurRadius: 20, offset: const Offset(0, 9), spreadRadius: -7)],
            ),
            child: Row(
              mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: widget.textColor, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(widget.label, style: TextStyle(color: widget.textColor, fontWeight: FontWeight.w800, fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
