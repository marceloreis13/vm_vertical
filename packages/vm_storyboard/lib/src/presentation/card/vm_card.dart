import 'package:flutter/material.dart';

import '../../domain/tokens/vm_theme_tokens_context.dart';

/// Standard surface card: soft shadow, rounded corners, consuming only
/// `VmThemeTokens`/`ThemeData`.
class VmCard extends StatelessWidget {
  const VmCard({required this.child, this.onTap, this.padding, super.key});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    final colorScheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(tokens.radius.lg);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: borderRadius,
        boxShadow: tokens.elevation.level1,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Padding(
            padding: padding ?? EdgeInsets.all(tokens.spacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}
