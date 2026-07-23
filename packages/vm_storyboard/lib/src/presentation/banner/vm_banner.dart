import 'package:flutter/material.dart';

import '../../domain/tokens/vm_theme_tokens_context.dart';

/// Persistent, dismissible banner (e.g. an offline notice), consuming only
/// `VmThemeTokens`/`ThemeData`.
class VmBanner extends StatelessWidget {
  const VmBanner({
    required this.message,
    this.icon = Icons.info_outline,
    this.onDismiss,
    super.key,
  });

  final String message;
  final IconData icon;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacing.md,
        vertical: tokens.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(tokens.radius.lg),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.onSecondaryContainer),
          SizedBox(width: tokens.spacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colorScheme.onSecondaryContainer),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(Icons.close, color: colorScheme.onSecondaryContainer),
              onPressed: onDismiss,
            ),
        ],
      ),
    );
  }
}
