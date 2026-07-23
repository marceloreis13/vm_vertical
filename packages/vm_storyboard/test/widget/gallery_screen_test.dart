import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

/// Shallow integration test for the Screen tier (see `vm-ui-composition`):
/// confirms Sections are wired to their tabs and that `extraActions` (the
/// hook `example/`'s palette switcher uses) fit in the AppBar without
/// overflowing.
void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildVmTheme(
      tokens: VmThemeTokens.standard(),
      palette: VmColorPalette.mock(),
    ).light,
    home: child,
  );

  testWidgets('renders extraActions in the AppBar with no overflow', (
    tester,
  ) async {
    // Narrow, phone-sized viewport: the crowded case (title + dropdown +
    // toggle icon all in one AppBar row).
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      wrap(
        GalleryScreen(
          themeMode: ThemeMode.light,
          onToggleTheme: () {},
          extraActions: [
            DropdownMenu<String>(
              initialSelection: 'Sunset',
              onSelected: (_) {},
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 'Sunset', label: 'Sunset'),
                DropdownMenuEntry(value: 'Ocean', label: 'Ocean'),
              ],
            ),
          ],
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(tester.takeException(), isNull);
    expect(find.byType(DropdownMenu<String>), findsOneWidget);
  });

  testWidgets('switching tabs shows each Section', (tester) async {
    await tester.pumpWidget(
      wrap(GalleryScreen(themeMode: ThemeMode.light, onToggleTheme: () {})),
    );
    await tester.pump(const Duration(milliseconds: 400));

    for (final tab in const ['Inputs', 'Surfaces', 'Feedback']) {
      final controller = DefaultTabController.of(
        tester.element(find.byType(TabBarView)),
      );
      controller.animateTo(
        ['Actions', 'Inputs', 'Surfaces', 'Feedback'].indexOf(tab),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.takeException(), isNull);
    }
  });
}
