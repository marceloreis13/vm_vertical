import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_logging/vm_logging.dart';
import 'package:vm_logging/src/presentation/demo/views/log_entry_tile_view.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

LogEntry _entry({
  required LogLevel level,
  required String message,
  Map<String, Object?> fields = const {},
}) => LogEntry(
  level: level,
  message: message,
  fields: fields,
  timestamp: DateTime(2026),
);

Future<void> _pumpTile(
  WidgetTester tester,
  Brightness brightness,
  LogEntry entry,
) async {
  final theme = buildVmTheme(
    tokens: VmThemeTokens.standard(),
    palette: VmColorPalette.mock(),
  );
  tester.view.physicalSize = const Size(420, 200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: brightness == Brightness.light ? theme.light : theme.dark,
      home: Scaffold(
        body: Center(child: LogEntryTileView(entry: entry)),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  for (final brightness in [Brightness.light, Brightness.dark]) {
    final themeName = brightness == Brightness.light ? 'light' : 'dark';

    testWidgets('info entry matches golden baseline ($themeName)', (
      tester,
    ) async {
      await _pumpTile(
        tester,
        brightness,
        _entry(
          level: LogLevel.info,
          message: 'User completed onboarding',
          fields: const {'userId': 42},
        ),
      );
      await expectLater(
        find.byType(LogEntryTileView),
        matchesGoldenFile('log_entry_tile_view_info_$themeName.png'),
      );
    });

    testWidgets(
      'error entry with masked field matches golden baseline ($themeName)',
      (tester) async {
        await _pumpTile(
          tester,
          brightness,
          _entry(
            level: LogLevel.error,
            message: 'Login attempt',
            fields: {'password': kRedactionPlaceholder},
          ),
        );
        await expectLater(
          find.byType(LogEntryTileView),
          matchesGoldenFile('log_entry_tile_view_error_$themeName.png'),
        );
      },
    );
  }
}
