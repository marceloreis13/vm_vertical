import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vm_navigation/vm_navigation.dart';

/// A real go_router `StatefulNavigationShell` is not constructible outside
/// a widget tree (it needs a live `GoRouter`/`StatefulShellRoute`). This
/// harness pumps a minimal two-branch `VmShellRoute` and hands back the
/// live shell instance, so `VmTabBarCubit` unit tests exercise the real
/// `goBranch`/`currentIndex` contract instead of a hand-rolled fake.
///
/// go_router hands a *fresh* `StatefulNavigationShell` instance to
/// `shellBuilder` on every rebuild triggered by navigation, so [shell]
/// always reflects the latest one; call [pumpAndSettle] after navigating to
/// refresh it.
class FakeShellHarness {
  FakeShellHarness._(this.tester, this.router);

  final WidgetTester tester;
  final GoRouter router;
  StatefulNavigationShell? shell;

  static Future<FakeShellHarness> pump(
    WidgetTester tester, {
    String initialLocation = '/a',
  }) async {
    late final FakeShellHarness harness;

    final shellRoute = VmShellRoute(
      branches: [
        VmBranch(
          routes: [
            GoRoute(
              path: '/a',
              builder: (context, state) => const Text('a-root'),
              routes: [
                GoRoute(
                  path: 'detail',
                  builder: (context, state) => const Text('a-detail'),
                ),
              ],
            ),
          ],
        ),
        VmBranch(
          routes: [
            GoRoute(
              path: '/b',
              builder: (context, state) => const Text('b-root'),
            ),
          ],
        ),
      ],
      shellBuilder: (context, state, shell) {
        harness.shell = shell;
        return Scaffold(body: shell);
      },
    );

    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [shellRoute.toRouteBase()],
    );
    addTearDown(router.dispose);

    harness = FakeShellHarness._(tester, router);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    return harness;
  }

  /// Navigates the router directly (independent of any Cubit), then
  /// refreshes [shell] to the instance the rebuild produced.
  Future<void> goLocation(String location) async {
    router.go(location);
    await tester.pumpAndSettle();
  }
}
