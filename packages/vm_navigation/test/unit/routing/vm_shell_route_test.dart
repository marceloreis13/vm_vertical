import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_navigation/vm_navigation.dart';

List<RouteBase> _moduleARoutes() => [
  GoRoute(path: '/a', builder: (context, state) => const SizedBox()),
];

List<RouteBase> _moduleBRoutes() => [
  GoRoute(path: '/b', builder: (context, state) => const SizedBox()),
];

void main() {
  group('VmShellRoute.toRouteBase', () {
    test('produces a single StatefulShellRoute RouteBase', () {
      final shellRoute = VmShellRoute(
        branches: [
          VmBranch(routes: _moduleARoutes()),
          VmBranch(routes: _moduleBRoutes()),
        ],
        shellBuilder: (context, state, shell) => const SizedBox(),
      );

      final routeBase = shellRoute.toRouteBase();

      expect(routeBase, isA<StatefulShellRoute>());
    });

    test('branches do not reference each other; each keeps its own routes', () {
      final branchA = VmBranch(routes: _moduleARoutes());
      final branchB = VmBranch(routes: _moduleBRoutes());

      expect(branchA.routes, isNot(same(branchB.routes)));
      expect((branchA.routes.single as GoRoute).path, '/a');
      expect((branchB.routes.single as GoRoute).path, '/b');
    });
  });
}
