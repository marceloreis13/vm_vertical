import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_tabbar/vm_tabbar.dart';

const _tabs = [
  VmTab(icon: Icons.home, label: 'Home', branchIndex: 0),
  VmTab(icon: Icons.search, label: 'Search', branchIndex: 1),
  VmTab(icon: Icons.person, label: 'Profile', branchIndex: 2),
];

Future<void> _pumpBar(WidgetTester tester, Brightness brightness) async {
  final theme = brightness == Brightness.light
      ? ThemeData.light()
      : ThemeData.dark();
  tester.view.physicalSize = const Size(420, 160);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: VmTabBar(
            tabs: _tabs,
            state: VmTabBarState(index: 1, badges: {2: const VmBadge.count(5)}),
            style: VmTabBarStyle.fromTheme(theme),
            onTap: (_) {},
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

    testWidgets('VmTabBar matches golden baseline ($themeName)', (
      tester,
    ) async {
      await _pumpBar(tester, brightness);
      await expectLater(
        find.byType(VmTabBar),
        matchesGoldenFile('vm_tab_bar_$themeName.png'),
      );
    });
  }
}
