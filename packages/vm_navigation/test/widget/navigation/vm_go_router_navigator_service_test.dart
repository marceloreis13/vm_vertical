import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vm_navigation/src/navigation/data/vm_go_router_navigator_service.dart';
import 'package:vm_navigation/vm_navigation.dart';

import '../../fakes/fake_vm_routes.dart';

/// Stands in for a real Cubit: constructed with only the service, holding
/// no `BuildContext`, matching how presentation code is expected to drive
/// navigation.
class _FakeCubit {
  _FakeCubit(this._navigator);

  final VmNavigatorService _navigator;

  void goToB() => _navigator.go(const FakeVmRoute('/b'));
}

void main() {
  late GlobalKey<NavigatorState> navigatorKey;
  late GoRouter router;
  late VmNavigatorService service;

  setUp(() {
    navigatorKey = GlobalKey<NavigatorState>();
    router = buildVmRouter(
      moduleRouteLists: [
        [
          const FakeVmRoute('/a').toRouteBase(),
          const FakeVmRoute('/b').toRouteBase(),
        ],
      ],
      navigatorKey: navigatorKey,
      initialLocation: '/a',
    );
    service = VmGoRouterNavigatorService(navigatorKey);
  });

  tearDown(() => router.dispose());

  Future<void> pumpRouter(WidgetTester tester) =>
      tester.pumpWidget(MaterialApp.router(routerConfig: router));

  group('VmGoRouterNavigatorService', () {
    testWidgets('go navigates to the target route', (tester) async {
      await pumpRouter(tester);
      expect(find.text('/a'), findsOneWidget);

      service.go(const FakeVmRoute('/b'));
      await tester.pumpAndSettle();

      expect(find.text('/b'), findsOneWidget);
    });

    testWidgets('push adds the target route on top of the stack', (
      tester,
    ) async {
      await pumpRouter(tester);

      service.push(const FakeVmRoute('/b'));
      await tester.pumpAndSettle();

      expect(find.text('/b'), findsOneWidget);
    });

    testWidgets('replace swaps the top of the stack', (tester) async {
      await pumpRouter(tester);

      service.replace(const FakeVmRoute('/b'));
      await tester.pumpAndSettle();

      expect(find.text('/b'), findsOneWidget);
      expect(find.text('/a'), findsNothing);
    });

    testWidgets('pop returns to the previous route', (tester) async {
      await pumpRouter(tester);

      service.push(const FakeVmRoute('/b'));
      await tester.pumpAndSettle();
      expect(find.text('/b'), findsOneWidget);

      service.pop();
      await tester.pumpAndSettle();

      expect(find.text('/a'), findsOneWidget);
    });

    testWidgets('a Cubit with no BuildContext can drive navigation', (
      tester,
    ) async {
      await pumpRouter(tester);

      _FakeCubit(service).goToB();
      await tester.pumpAndSettle();

      expect(find.text('/b'), findsOneWidget);
    });
  });
}
