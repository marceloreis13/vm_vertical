import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vm_navigation/vm_navigation.dart';

/// A minimal stateful page whose in-memory counter proves branch 0 is not
/// rebuilt from scratch when the user switches away and back.
class _CounterPage extends StatefulWidget {
  const _CounterPage();

  @override
  State<_CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<_CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('count:$_count'),
          TextButton(
            onPressed: () => setState(() => _count++),
            child: const Text('increment'),
          ),
        ],
      ),
    );
  }
}

List<RouteBase> _branchARoutes() => [
  GoRoute(path: '/a', builder: (context, state) => const _CounterPage()),
];

List<RouteBase> _branchBRoutes() => [
  GoRoute(path: '/b', builder: (context, state) => const Text('branch-b')),
];

List<RouteBase> _otherModuleRoutes() => [
  GoRoute(path: '/other', builder: (context, state) => const Text('other')),
];

/// Builds a router with one [VmShellRoute] of two branches (`/a`, `/b`),
/// exposing a way to read the last [StatefulNavigationShell] the shell view
/// was invoked with.
GoRouter _buildRouter({
  required ValueChanged<StatefulNavigationShell> onShell,
  String initialLocation = '/a',
  bool includeOtherModule = false,
}) {
  final shellRoute = VmShellRoute(
    branches: [
      VmBranch(routes: _branchARoutes()),
      VmBranch(routes: _branchBRoutes()),
    ],
    shellBuilder: (context, state, shell) {
      onShell(shell);
      return Scaffold(
        body: shell,
        bottomNavigationBar: Row(
          children: [
            TextButton(
              onPressed: () => shell.goBranch(0),
              child: const Text('go-a'),
            ),
            TextButton(
              onPressed: () => shell.goBranch(1),
              child: const Text('go-b'),
            ),
          ],
        ),
      );
    },
  );

  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      shellRoute.toRouteBase(),
      if (includeOtherModule) ..._otherModuleRoutes(),
    ],
  );
}

void main() {
  group('VmShellRoute', () {
    testWidgets('aggregates branches as one RouteBase, no branch coupling', (
      tester,
    ) async {
      final router = _buildRouter(onShell: (_) {}, includeOtherModule: true);
      addTearDown(router.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      expect(find.text('count:0'), findsOneWidget);

      router.go('/other');
      await tester.pumpAndSettle();
      expect(find.text('other'), findsOneWidget);
    });

    testWidgets('coexists with flat module routes; signature unchanged', (
      tester,
    ) async {
      final router = _buildRouter(onShell: (_) {}, includeOtherModule: true);
      addTearDown(router.dispose);

      final paths = router.configuration.routes.whereType<GoRoute>().map(
        (route) => route.path,
      );
      expect(paths, contains('/other'));
    });

    testWidgets('switching branches preserves state (no rebuild)', (
      tester,
    ) async {
      final router = _buildRouter(onShell: (_) {});
      addTearDown(router.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      expect(find.text('count:0'), findsOneWidget);

      await tester.tap(find.text('increment'));
      await tester.pump();
      expect(find.text('count:1'), findsOneWidget);

      await tester.tap(find.text('go-b'));
      await tester.pumpAndSettle();
      expect(find.text('branch-b'), findsOneWidget);

      await tester.tap(find.text('go-a'));
      await tester.pumpAndSettle();
      expect(find.text('count:1'), findsOneWidget);
    });

    testWidgets('shell view receives the live StatefulNavigationShell', (
      tester,
    ) async {
      StatefulNavigationShell? received;
      final router = _buildRouter(onShell: (shell) => received = shell);
      addTearDown(router.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      expect(received, isNotNull);
      expect(received!.currentIndex, 0);
    });

    testWidgets('deep link resolves to the owning branch', (tester) async {
      StatefulNavigationShell? received;
      final router = _buildRouter(
        onShell: (shell) => received = shell,
        initialLocation: '/b',
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      expect(find.text('branch-b'), findsOneWidget);
      expect(received!.currentIndex, 1);
    });
  });
}
