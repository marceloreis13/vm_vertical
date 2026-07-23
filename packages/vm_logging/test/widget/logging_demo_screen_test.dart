import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_logging/vm_logging.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

void main() {
  late GetIt getIt;
  late ConsoleLogSink consoleSink;
  late VmTheme theme;

  setUp(() {
    getIt = GetIt.asNewInstance();
    registerVmStoryboardModule(
      getIt,
      config: VmThemeConfig(
        palette: VmColorPalette.mock(),
        logo: VmLogo.mock(),
      ),
    );
    theme = getIt<VmTheme>();
    consoleSink = ConsoleLogSink();
    registerVmLogging(
      getIt,
      config: VmLoggingConfig(
        sinks: [SinkRegistration(sink: consoleSink, minLevel: LogLevel.trace)],
        sensitiveKeys: const {'password'},
      ),
    );
  });

  tearDown(() async {
    await consoleSink.dispose();
    await getIt.reset();
  });

  Widget buildApp() => MaterialApp(
    theme: theme.light,
    home: LoggingDemoScreen(consoleSink: consoleSink, getIt: getIt),
  );

  testWidgets('emitting a level renders the entry on-screen', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.text('Info'));
    await tester.pump();

    expect(
      find.textContaining('Info: user completed onboarding'),
      findsOneWidget,
    );
    expect(find.text('INFO'), findsOneWidget);
  });

  testWidgets('emitting sensitive data renders it masked, not in clear', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.text('Sensitive data'));
    await tester.pump();

    expect(find.textContaining('hunter2'), findsNothing);
    expect(find.textContaining(kRedactionPlaceholder), findsOneWidget);
  });

  testWidgets('empty state renders before any log is emitted', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.textContaining('No logs yet'), findsOneWidget);
  });
}
