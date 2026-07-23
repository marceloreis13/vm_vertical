import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vm_navigation/vm_navigation.dart';

import '../../fakes/fake_vm_routes.dart';

/// Two independent fake "modules" — neither imports or references the
/// other's route classes, mirroring how real vm_* modules would coexist.
List<RouteBase> _moduleARoutes() => [const FakeVmRoute('/a').toRouteBase()];

List<RouteBase> _moduleBRoutes() => [const FakeVmRoute('/b').toRouteBase()];

void main() {
  group('buildVmRouter', () {
    test(
      'two independent fake modules aggregate without referencing each other',
      () {
        final router = buildVmRouter(
          moduleRouteLists: [_moduleARoutes(), _moduleBRoutes()],
          navigatorKey: GlobalKey<NavigatorState>(),
          initialLocation: '/a',
        );
        addTearDown(router.dispose);

        final paths = router.configuration.routes.whereType<GoRoute>().map(
          (route) => route.path,
        );

        expect(paths, unorderedEquals(['/a', '/b']));
      },
    );

    test("removing a module's route list leaves the other module's routes "
        'intact', () {
      final router = buildVmRouter(
        moduleRouteLists: [_moduleARoutes()],
        navigatorKey: GlobalKey<NavigatorState>(),
        initialLocation: '/a',
      );
      addTearDown(router.dispose);

      final paths = router.configuration.routes.whereType<GoRoute>().map(
        (route) => route.path,
      );

      expect(paths, ['/a']);
    });
  });
}
