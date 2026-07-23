import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_config/src/presentation/demo/views/config_field_tile_view.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

Future<void> _pumpTile(WidgetTester tester, Brightness brightness) async {
  final theme = buildVmTheme(
    tokens: VmThemeTokens.standard(),
    palette: VmColorPalette.mock(),
  );
  tester.view.physicalSize = const Size(420, 320);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: brightness == Brightness.light ? theme.light : theme.dark,
      home: Scaffold(
        body: Center(
          child: ConfigFieldTileView(
            label: 'New checkout flow',
            defaultDisplay: 'false',
            cacheDisplay: 'true',
            remoteDisplay: 'true',
            resolvedDisplay: 'true',
            action: Switch.adaptive(value: true, onChanged: (_) {}),
            onClearRemote: () {},
          ),
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  for (final brightness in [Brightness.light, Brightness.dark]) {
    final themeName = brightness == Brightness.light ? 'light' : 'dark';

    testWidgets('config field tile matches golden baseline ($themeName)', (
      tester,
    ) async {
      await _pumpTile(tester, brightness);
      await expectLater(
        find.byType(ConfigFieldTileView),
        matchesGoldenFile('config_field_tile_view_$themeName.png'),
      );
    });
  }
}
