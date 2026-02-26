import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class NeoActionButton extends StatefulWidget {
  const NeoActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.enabled = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool enabled;
  final IconData? icon;

  @override
  State<NeoActionButton> createState() => _NeoActionButtonState();
}

class _NeoActionButtonState extends State<NeoActionButton> {
  bool _pressed = false;

  bool get _isEnabled => widget.enabled && !widget.loading && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final color = _isEnabled
        ? (_pressed ? AppColors.learningPrimaryDark : AppColors.learningPrimary)
      : AppColors.neutral300;
    final borderColor = _isEnabled
      ? (_pressed ? AppColors.learningPrimaryDark : AppColors.learningPrimaryDark)
      : AppColors.neutral300;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _isEnabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: _isEnabled ? () => setState(() => _pressed = false) : null,
      onTapUp: _isEnabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 110),
        height: 58,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: _pressed
              ? const []
              : [
                  BoxShadow(
                    color: borderColor,
                    blurRadius: 0,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Center(
          child: widget.loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.6,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 20, color: Colors.white),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: _isEnabled ? Colors.white : AppColors.neutral500,
                          ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
