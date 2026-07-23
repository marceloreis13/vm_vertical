import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

const _tabs = ['Actions', 'Inputs', 'Surfaces', 'Feedback'];

Future<void> _pumpGallery(WidgetTester tester, Brightness brightness) async {
  final theme = buildVmTheme(
    tokens: VmThemeTokens.standard(),
    palette: VmColorPalette.mock(),
  );
  await tester.pumpWidget(
    MaterialApp(
      theme: brightness == Brightness.light ? theme.light : theme.dark,
      home: GalleryScreen(
        themeMode: brightness == Brightness.light
            ? ThemeMode.light
            : ThemeMode.dark,
        onToggleTheme: () {},
      ),
    ),
  );
  // Not pumpAndSettle: the Feedback tab's VmLoadingView animates
  // indefinitely, so settling never converges.
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  for (final brightness in [Brightness.light, Brightness.dark]) {
    final themeName = brightness == Brightness.light ? 'light' : 'dark';

    for (final tab in _tabs) {
      testWidgets('gallery "$tab" tab matches golden baseline ($themeName)', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(420, 1500);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await _pumpGallery(tester, brightness);
        if (tab != _tabs.first) {
          // animateTo, not `controller.index = ...`: TabBarView only warps
          // its PageView to the new page while `indexIsChanging` stays true,
          // which an instant index assignment clears before the next frame.
          // We still can't pumpAndSettle (the Feedback tab's VmLoadingView
          // animates indefinitely), so pump past the animation duration
          // instead.
          final controller = DefaultTabController.of(
            tester.element(find.byType(TabBarView)),
          );
          controller.animateTo(_tabs.indexOf(tab));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));
        }

        await expectLater(
          find.byType(GalleryScreen),
          matchesGoldenFile('gallery_${tab.toLowerCase()}_$themeName.png'),
        );
      });
    }
  }
}
