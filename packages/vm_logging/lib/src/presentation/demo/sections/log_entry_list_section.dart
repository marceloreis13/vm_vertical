import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../domain/log_entry.dart';
import '../logging_demo_cubit.dart';
import '../views/log_entry_tile_view.dart';

/// Renders the live list of entries the demo has emitted so far, newest
/// first, reading [LoggingDemoCubit]'s state directly — a Section, not a
/// View.
class LogEntryListSection extends StatelessWidget {
  const LogEntryListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoggingDemoCubit, List<LogEntry>>(
      builder: (context, entries) {
        if (entries.isEmpty) {
          return const VmEmptyView(
            message: 'No logs yet. Tap a button above to emit a log entry.',
          );
        }
        final tokens = context.vmTokens;
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: tokens.spacing.md),
          itemCount: entries.length,
          separatorBuilder: (_, _) => SizedBox(height: tokens.spacing.sm),
          itemBuilder: (context, index) =>
              LogEntryTileView(entry: entries[entries.length - 1 - index]),
        );
      },
    );
  }
}
