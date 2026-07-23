import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_notifications/src/domain/notification_kind.dart';
import 'package:vm_notifications/src/domain/notification_payload.dart';
import 'package:vm_notifications/src/presentation/demo/views/notification_log_tile_view.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

const _payload = NotificationPayload(
  title: 'Simulated push',
  body: 'Tap to route to the target screen',
  kind: NotificationKind.push,
);

Future<void> _pumpTile(WidgetTester tester, Brightness brightness) async {
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
      home: const Scaffold(
        body: Center(child: NotificationLogTileView(payload: _payload)),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  for (final brightness in [Brightness.light, Brightness.dark]) {
    final themeName = brightness == Brightness.light ? 'light' : 'dark';

    testWidgets('notification log tile matches golden baseline ($themeName)', (
      tester,
    ) async {
      await _pumpTile(tester, brightness);
      await expectLater(
        find.byType(NotificationLogTileView),
        matchesGoldenFile('notification_log_tile_view_$themeName.png'),
      );
    });
  }
}
