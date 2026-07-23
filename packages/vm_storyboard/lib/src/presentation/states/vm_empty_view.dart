import 'package:flutter/material.dart';

import '../../domain/tokens/vm_theme_tokens_context.dart';
import '../button/vm_button.dart';

/// Standard empty state, consuming only `VmThemeTokens`/`ThemeData`.
class VmEmptyView extends StatelessWidget {
  const VmEmptyView({
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(tokens.spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: colorScheme.onSurfaceVariant),
            SizedBox(height: tokens.spacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: tokens.spacing.md),
              VmButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: VmButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
