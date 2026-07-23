import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_analytics/src/presentation/demo/views/analytics_call_tile_view.dart';
import 'package:vm_analytics/vm_analytics.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

Future<void> _pumpTile(
  WidgetTester tester,
  Brightness brightness,
  AnalyticsCall call,
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
        body: Center(child: AnalyticsCallTileView(call: call)),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  for (final brightness in [Brightness.light, Brightness.dark]) {
    final themeName = brightness == Brightness.light ? 'light' : 'dark';

    testWidgets('event call matches golden baseline ($themeName)', (
      tester,
    ) async {
      await _pumpTile(
        tester,
        brightness,
        AnalyticsCall.logEvent(
          AnalyticsEvent(
            name: 'checkout_started',
            parameters: const {'item_count': 3},
          ),
        ),
      );
      await expectLater(
        find.byType(AnalyticsCallTileView),
        matchesGoldenFile('analytics_call_tile_view_event_$themeName.png'),
      );
    });

    testWidgets('screen view call matches golden baseline ($themeName)', (
      tester,
    ) async {
      await _pumpTile(
        tester,
        brightness,
        const AnalyticsCall.screenView('home'),
      );
      await expectLater(
        find.byType(AnalyticsCallTileView),
        matchesGoldenFile('analytics_call_tile_view_screen_$themeName.png'),
      );
    });
  }
}
