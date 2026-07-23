import 'package:flutter/material.dart';

import '../../domain/tokens/vm_theme_tokens_context.dart';

/// Shows a standard snackbar that auto-dismisses after [duration],
/// consuming only `VmThemeTokens`/`ThemeData`.
void showVmSnackbar(
  BuildContext context,
  String message, {
  Duration? duration,
}) {
  final tokens = context.vmTokens;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration ?? const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radius.md),
      ),
    ),
  );
}
