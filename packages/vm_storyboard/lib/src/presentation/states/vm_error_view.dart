import 'package:flutter/material.dart';

import '../../domain/tokens/vm_theme_tokens_context.dart';
import '../button/vm_button.dart';

/// Standard error state, consuming only `VmThemeTokens`/`ThemeData`.
class VmErrorView extends StatelessWidget {
  const VmErrorView({required this.message, this.onRetry, super.key});

  final String message;
  final VoidCallback? onRetry;

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
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            SizedBox(height: tokens.spacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              SizedBox(height: tokens.spacing.md),
              VmButton(label: 'Retry', onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
