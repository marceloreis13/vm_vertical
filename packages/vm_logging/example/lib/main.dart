import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_logging/vm_logging.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

final getIt = GetIt.instance;

/// Thin runnable shell: registers `vm_storyboard` (theme) and `vm_logging`
/// (with mock, easy-to-tweak config) then runs `LoggingDemoScreen`, which
/// lives in `package:vm_logging` itself so any app can embed it the same
/// way (see `docs/module-scaffold.md`).
void main() {
  registerVmStoryboardModule(
    getIt,
    config: VmThemeConfig(palette: VmColorPalette.mock(), logo: VmLogo.mock()),
  );

  // Easy to tweak: swap/add sinks, change per-sink minLevel, or extend the
  // sensitive-key set and redactors below.
  final consoleSink = ConsoleLogSink();
  registerVmLogging(
    getIt,
    config: VmLoggingConfig(
      sinks: [
        SinkRegistration(sink: consoleSink, minLevel: LogLevel.trace),
        const SinkRegistration(sink: NoopLogSink(), minLevel: LogLevel.error),
      ],
      sensitiveKeys: const {'password', 'authorization'},
      redactors: [
        RegexRedactor(RegExp(r'[\w.+-]+@[\w-]+\.[\w.-]+')), // emails
      ],
    ),
  );

  runApp(VmLoggingExampleApp(consoleSink: consoleSink));
}

class VmLoggingExampleApp extends StatelessWidget {
  const VmLoggingExampleApp({required this.consoleSink, super.key});

  final ConsoleLogSink consoleSink;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<VmTheme>();
    return MaterialApp(
      title: 'vm_logging example',
      theme: theme.light,
      darkTheme: theme.dark,
      home: LoggingDemoScreen(consoleSink: consoleSink),
    );
  }
}
