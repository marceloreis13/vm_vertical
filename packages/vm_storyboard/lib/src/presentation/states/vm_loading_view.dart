import 'package:flutter/material.dart';

import '../../domain/tokens/vm_theme_tokens_context.dart';

/// Standard loading state, consuming only `VmThemeTokens`/`ThemeData`.
class VmLoadingView extends StatelessWidget {
  const VmLoadingView({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            SizedBox(height: tokens.spacing.md),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
