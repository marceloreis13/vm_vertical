import 'package:flutter/material.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../domain/analytics_call.dart';

/// Renders one already-delivered [AnalyticsCall]: a kind tag plus its
/// description. Takes plain constructor parameters only — no Cubit/State/
/// repository — so it is a pure View, reusable wherever an [AnalyticsCall]
/// needs display.
class AnalyticsCallTileView extends StatelessWidget {
  const AnalyticsCallTileView({required this.call, super.key});

  final AnalyticsCall call;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    return VmCard(
      child: Row(
        children: [
          _KindTag(call: call),
          SizedBox(width: tokens.spacing.sm),
          Expanded(
            child: Text(
              call.describe(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _KindTag extends StatelessWidget {
  const _KindTag({required this.call});

  final AnalyticsCall call;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    final colorScheme = Theme.of(context).colorScheme;
    final (label, color) = switch (call) {
      LogEventCall() => ('EVENT', colorScheme.primary),
      SetUserPropertyCall() => ('PROPERTY', colorScheme.secondary),
      ScreenViewCall() => ('SCREEN', colorScheme.tertiary),
      SetUserIdCall() => ('IDENTITY', colorScheme.outline),
      ResetCall() => ('RESET', colorScheme.error),
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacing.sm,
        vertical: tokens.spacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(tokens.radius.sm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
