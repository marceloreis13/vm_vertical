import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_tabbar/vm_tabbar.dart';

import '../../fakes/fake_shell_harness.dart';

VmTab _tab(int branchIndex, {ValueListenable<VmBadge?>? badge}) => VmTab(
  icon: Icons.circle,
  label: 'tab$branchIndex',
  branchIndex: branchIndex,
  badge: badge,
);

void main() {
  group('VmTabBarCubit', () {
    testWidgets('seeds index from shell.currentIndex', (tester) async {
      final harness = await FakeShellHarness.pump(tester);
      final cubit = VmTabBarCubit(
        shell: harness.shell!,
        tabs: [_tab(0), _tab(1)],
      );
      addTearDown(cubit.close);

      expect(cubit.state.index, 0);
    });

    testWidgets('select delegates to shell.goBranch and updates state', (
      tester,
    ) async {
      final harness = await FakeShellHarness.pump(tester);
      final cubit = VmTabBarCubit(
        shell: harness.shell!,
        tabs: [_tab(0), _tab(1)],
      );
      addTearDown(cubit.close);

      cubit.select(1);
      await tester.pumpAndSettle();

      expect(cubit.state.index, 1);
      expect(find.text('b-root'), findsOneWidget);
    });

    testWidgets('re-tapping the active tab returns its branch to root', (
      tester,
    ) async {
      final harness = await FakeShellHarness.pump(tester);
      final cubit = VmTabBarCubit(
        shell: harness.shell!,
        tabs: [_tab(0), _tab(1)],
      );
      addTearDown(cubit.close);

      // Push a sub-route onto branch 0.
      await harness.goLocation('/a/detail');
      expect(find.text('a-detail'), findsOneWidget);

      // Re-tap the active tab (index 0): returns the branch to its root.
      cubit.select(0);
      await tester.pumpAndSettle();

      expect(find.text('a-root'), findsOneWidget);
      expect(cubit.state.index, 0);
    });

    testWidgets('syncWithShell reconciles index after external navigation', (
      tester,
    ) async {
      final harness = await FakeShellHarness.pump(tester);
      final cubit = VmTabBarCubit(
        shell: harness.shell!,
        tabs: [_tab(0), _tab(1)],
      );
      addTearDown(cubit.close);

      // Navigate outside the Cubit (e.g. a deep link).
      await harness.goLocation('/b');

      expect(cubit.state.index, 0); // stale until reconciled
      cubit.syncWithShell(harness.shell!);

      expect(cubit.state.index, 1);
    });

    testWidgets('folds each tab badge into state, seeded on construction', (
      tester,
    ) async {
      final harness = await FakeShellHarness.pump(tester);
      final badge0 = ValueNotifier<VmBadge?>(const VmBadge.count(3));
      final cubit = VmTabBarCubit(
        shell: harness.shell!,
        tabs: [
          _tab(0, badge: badge0),
          _tab(1),
        ],
      );
      addTearDown(cubit.close);

      expect(cubit.state.badges[0], const VmBadge.count(3));
      expect(cubit.state.badges[1], isNull);
    });

    testWidgets('badge updates live without reconfiguring the tab list', (
      tester,
    ) async {
      final harness = await FakeShellHarness.pump(tester);
      final badge0 = ValueNotifier<VmBadge?>(const VmBadge.count(1));
      final cubit = VmTabBarCubit(
        shell: harness.shell!,
        tabs: [_tab(0, badge: badge0)],
      );
      addTearDown(cubit.close);

      badge0.value = const VmBadge.count(2);

      expect(cubit.state.badges[0], const VmBadge.count(2));
    });

    testWidgets('close() releases every badge subscription', (tester) async {
      final harness = await FakeShellHarness.pump(tester);
      final badge0 = ValueNotifier<VmBadge?>(const VmBadge.count(1));
      final cubit = VmTabBarCubit(
        shell: harness.shell!,
        tabs: [_tab(0, badge: badge0)],
      );

      await cubit.close();

      // If the Cubit had not unsubscribed, notifying would call emit() on a
      // closed Cubit and throw a StateError.
      expect(() => badge0.value = const VmBadge.count(9), returnsNormally);
    });
  });
}
