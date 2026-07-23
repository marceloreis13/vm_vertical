import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_tabbar/vm_tabbar.dart';

const _tabs = [
  VmTab(icon: Icons.home, label: 'Home', branchIndex: 0),
  VmTab(icon: Icons.search, label: 'Search', branchIndex: 1),
  VmTab(icon: Icons.person, label: 'Profile', branchIndex: 2),
];

Future<void> _pump(
  WidgetTester tester, {
  required VmTabBarState state,
  required ValueChanged<int> onTap,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        bottomNavigationBar: VmTabBar(
          tabs: _tabs,
          state: state,
          style: VmTabBarStyle.fromTheme(ThemeData.light()),
          onTap: onTap,
        ),
      ),
    ),
  );
}

void main() {
  group('VmTabBar', () {
    testWidgets('renders one item per tab in order', (tester) async {
      await _pump(tester, state: VmTabBarState.initial(), onTap: (_) {});

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('tapping the third item requests selection of index 2', (
      tester,
    ) async {
      int? selected;
      await _pump(
        tester,
        state: VmTabBarState.initial(),
        onTap: (i) => selected = i,
      );

      await tester.tap(find.text('Profile'));
      await tester.pump();

      expect(selected, 2);
    });

    testWidgets('shows a count badge when the tab has one', (tester) async {
      await _pump(
        tester,
        state: VmTabBarState(index: 0, badges: {0: const VmBadge.count(3)}),
        onTap: (_) {},
      );

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('shows no badge when absent', (tester) async {
      await _pump(tester, state: VmTabBarState.initial(), onTap: (_) {});

      expect(find.text('3'), findsNothing);
    });
  });
}
