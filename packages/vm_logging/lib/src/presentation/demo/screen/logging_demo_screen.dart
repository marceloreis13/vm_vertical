import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../data/sinks/console_log_sink.dart';
import '../../../domain/logger.dart';
import '../logging_demo_cubit.dart';
import '../sections/emit_controls_section.dart';
import '../sections/log_entry_list_section.dart';

/// Entry point of the `vm_logging` visual example. Resolves the
/// app-registered [Logger] and the [ConsoleLogSink] instance the app wired
/// into it (via `registerVmLogging`) and drives [LoggingDemoCubit] with
/// them. Lives in `lib/`, not `example/`, so any other app (e.g.
/// `app_showcase`) can embed it directly — see `docs/module-scaffold.md`.
class LoggingDemoScreen extends StatelessWidget {
  const LoggingDemoScreen({required this.consoleSink, this.getIt, super.key});

  /// The [ConsoleLogSink] instance registered into `VmLoggingConfig`, so
  /// the demo can subscribe to exactly what was delivered to it.
  final ConsoleLogSink consoleSink;

  /// Defaults to [GetIt.instance]; overridable for tests/embedding apps
  /// with a scoped container.
  final GetIt? getIt;

  @override
  Widget build(BuildContext context) {
    final container = getIt ?? GetIt.instance;
    final logger = container<Logger>();

    return BlocProvider(
      create: (_) => LoggingDemoCubit(logger: logger, sink: consoleSink),
      child: Scaffold(
        appBar: const VmAppBar(title: 'vm_logging example'),
        body: const Column(
          children: [
            EmitControlsSection(),
            Expanded(child: LogEntryListSection()),
          ],
        ),
      ),
    );
  }
}
