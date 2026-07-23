import 'package:flutter/material.dart';

import '../../domain/tokens/vm_theme_tokens_context.dart';

/// The visual weight of a [VmButton].
enum VmButtonVariant { primary, secondary, text }

/// Standard button, consuming only `VmThemeTokens`/`ThemeData`.
class VmButton extends StatelessWidget {
  const VmButton({
    required this.label,
    required this.onPressed,
    this.variant = VmButtonVariant.primary,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final VmButtonVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(tokens.radius.md),
    );
    final padding = EdgeInsets.symmetric(
      horizontal: tokens.spacing.lg,
      vertical: tokens.spacing.sm,
    );
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18),
              SizedBox(width: tokens.spacing.xs),
              Text(label),
            ],
          );

    return switch (variant) {
      VmButtonVariant.primary => FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(shape: shape, padding: padding),
        child: child,
      ),
      VmButtonVariant.secondary => OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(shape: shape, padding: padding),
        child: child,
      ),
      VmButtonVariant.text => TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(shape: shape, padding: padding),
        child: child,
      ),
    };
  }
}
