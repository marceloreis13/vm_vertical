import 'package:flutter/material.dart';

import '../../domain/tokens/vm_theme_tokens_context.dart';

/// Small notification indicator, wrapping [child] with a count/dot badge in
/// its top-right corner, consuming only `VmThemeTokens`/`ThemeData`.
class VmBadge extends StatelessWidget {
  const VmBadge({required this.child, this.count, super.key});

  final Widget child;

  /// Number to display. `null` renders a plain dot; `0` hides the badge.
  final int? count;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return child;
    final tokens = context.vmTokens;
    final colorScheme = Theme.of(context).colorScheme;
    return Badge(
      label: count == null ? null : Text('$count'),
      isLabelVisible: true,
      backgroundColor: colorScheme.error,
      textColor: colorScheme.onError,
      smallSize: tokens.spacing.sm,
      largeSize: tokens.spacing.md,
      child: child,
    );
  }
}
