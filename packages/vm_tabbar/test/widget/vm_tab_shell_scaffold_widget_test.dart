import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:vm_navigation/vm_navigation.dart';
import 'package:vm_tabbar/vm_tabbar.dart';

class _CounterScreen extends StatefulWidget {
  const _CounterScreen();

  @override
  State<_CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<_CounterScreen> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('count:$_count'),
        TextButton(
          onPressed: () => setState(() => _count++),
          child: const Text('increment'),
        ),
      ],
    );
  }
}

GetIt _buildGetIt(List<VmTab> tabs) {
  final getIt = GetIt.asNewInstance();
  getIt.registerSingleton<VmTabbarConfig>(VmTabbarConfig(tabs: tabs));
  return getIt;
}

GoRouter _buildRouter(GetIt getIt, {String initialLocation = '/home'}) {
  final shellRoute = VmShellRoute(
    branches: [
      VmBranch(
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const _CounterScreen(),
          ),
        ],
      ),
      VmBranch(
        routes: [
          GoRoute(
            path: '/search',
            builder: (context, state) => const Text('search'),
          ),
        ],
      ),
    ],
    shellBuilder: (context, state, shell) =>
        VmTabShellScaffold(shell: shell, getIt: getIt),
  );

  return GoRouter(
    initialLocation: initialLocation,
    routes: [shellRoute.toRouteBase()],
  );
}

void main() {
  group('VmTabShellScaffold', () {
    testWidgets('tapping a tab switches branch and preserves state', (
      tester,
    ) async {
      final getIt = _buildGetIt(const [
        VmTab(icon: Icons.home, label: 'Home', branchIndex: 0),
        VmTab(icon: Icons.search, label: 'Search', branchIndex: 1),
      ]);
      final router = _buildRouter(getIt);
      addTearDown(router.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      expect(find.text('count:0'), findsOneWidget);

      await tester.tap(find.text('increment'));
      await tester.pump();
      expect(find.text('count:1'), findsOneWidget);

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(find.text('search'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('count:1'), findsOneWidget);
    });

    testWidgets('deep link sets the active tab', (tester) async {
      final getIt = _buildGetIt(const [
        VmTab(icon: Icons.home, label: 'Home', branchIndex: 0),
        VmTab(icon: Icons.search, label: 'Search', branchIndex: 1),
      ]);
      final router = _buildRouter(getIt, initialLocation: '/search');
      addTearDown(router.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(find.text('search'), findsOneWidget);

      // Tapping Home now switches away from the deep-linked Search branch,
      // proving the Cubit's index was reconciled to the deep link (1), not
      // stuck at its seeded default (0).
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('count:0'), findsOneWidget);
    });
  });
}
