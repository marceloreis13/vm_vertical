import 'package:flutter/material.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../domain/log_entry.dart';
import '../../../domain/log_level.dart';

/// Renders one already-redacted [LogEntry]: level tag, message and fields.
/// Takes plain constructor parameters only — no Cubit/State/repository —
/// so it is a pure View, reusable wherever a [LogEntry] needs display.
class LogEntryTileView extends StatelessWidget {
  const LogEntryTileView({required this.entry, super.key});

  final LogEntry entry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    return VmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _LevelTag(level: entry.level),
              SizedBox(width: tokens.spacing.sm),
              Expanded(
                child: Text(
                  entry.message,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          if (entry.fields.isNotEmpty) ...[
            SizedBox(height: tokens.spacing.xs),
            Text(
              entry.fields.entries
                  .map((field) => '${field.key}: ${field.value}')
                  .join('  ·  '),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _LevelTag extends StatelessWidget {
  const _LevelTag({required this.level});

  final LogLevel level;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    final colorScheme = Theme.of(context).colorScheme;
    final color = switch (level) {
      LogLevel.trace => colorScheme.outline,
      LogLevel.debug => colorScheme.secondary,
      LogLevel.info => colorScheme.primary,
      LogLevel.warn => colorScheme.tertiary,
      LogLevel.error => colorScheme.error,
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
        level.name.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
