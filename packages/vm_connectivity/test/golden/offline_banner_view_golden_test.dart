import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_connectivity/vm_connectivity.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

Future<void> _pumpBanner(WidgetTester tester, Brightness brightness) async {
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
      home: const Scaffold(body: Center(child: OfflineBannerView())),
    ),
  );
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  for (final brightness in [Brightness.light, Brightness.dark]) {
    final themeName = brightness == Brightness.light ? 'light' : 'dark';

    testWidgets('offline banner matches golden baseline ($themeName)', (
      tester,
    ) async {
      await _pumpBanner(tester, brightness);
      await expectLater(
        find.byType(OfflineBannerView),
        matchesGoldenFile('offline_banner_view_$themeName.png'),
      );
    });
  }
}
