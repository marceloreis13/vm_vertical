import 'package:flutter/material.dart';

import '../../domain/tokens/vm_theme_tokens_context.dart';

/// Shows a standard confirmation dialog, consuming only
/// `VmThemeTokens`/`ThemeData`. Returns the value passed to
/// `Navigator.pop`, or `null` if dismissed.
Future<T?> showVmDialog<T>(
  BuildContext context, {
  required String title,
  required String message,
  List<Widget> actions = const [],
}) {
  final tokens = context.vmTokens;
  return showDialog<T>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: actions.isEmpty
          ? [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ]
          : actions,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radius.lg),
      ),
    ),
  );
}
