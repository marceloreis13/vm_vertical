import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../fakes/fake_vm_routes.dart';

class _MockBuildContext extends Mock implements BuildContext {}

class _MockGoRouterState extends Mock implements GoRouterState {}

void main() {
  late BuildContext context;
  late GoRouterState state;

  setUp(() {
    context = _MockBuildContext();
    state = _MockGoRouterState();
  });

  group('VmRoute.toRouteBase', () {
    test('unguarded route has no redirect', () {
      final route = const FakeVmRoute('/unguarded').toRouteBase() as GoRoute;

      expect(route.path, '/unguarded');
      expect(route.redirect, isNull);
    });

    test('allowed route does not redirect', () async {
      final route =
          const FakeGuardedVmRoute(
                '/guarded',
                guards: [FakeAllowGuard()],
                guardFallbackPath: '/fallback',
              ).toRouteBase()
              as GoRoute;

      final result = await route.redirect!(context, state);

      expect(result, isNull);
    });

    test('blocked route redirects to the configured fallback', () async {
      final route =
          const FakeGuardedVmRoute(
                '/guarded',
                guards: [FakeDenyGuard()],
                guardFallbackPath: '/fallback',
              ).toRouteBase()
              as GoRoute;

      final result = await route.redirect!(context, state);

      expect(result, '/fallback');
    });

    test('an async guard is awaited before resolving', () async {
      final route =
          const FakeGuardedVmRoute(
                '/guarded',
                guards: [FakeAsyncAllowGuard()],
                guardFallbackPath: '/fallback',
              ).toRouteBase()
              as GoRoute;

      final result = await route.redirect!(context, state);

      expect(result, isNull);
    });

    test('multiple guards combine as a logical AND', () async {
      final route =
          const FakeGuardedVmRoute(
                '/guarded',
                guards: [FakeAllowGuard(), FakeAsyncDenyGuard()],
                guardFallbackPath: '/fallback',
              ).toRouteBase()
              as GoRoute;

      final result = await route.redirect!(context, state);

      expect(result, '/fallback');
    });

    test('no external URI parsing: redirect never inspects state', () async {
      // The mock GoRouterState has no stubs configured; if VmRoute's
      // redirect resolution tried to read/parse anything from it (a URI,
      // query params, etc.) this would throw a MissingStubError.
      final route =
          const FakeGuardedVmRoute(
                '/guarded',
                guards: [FakeDenyGuard()],
                guardFallbackPath: '/fallback',
              ).toRouteBase()
              as GoRoute;

      await expectLater(route.redirect!(context, state), completes);
    });
  });
}
