import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:vm_navigation/vm_navigation.dart';

/// Always-allowing [RouteGuard], for tests.
class FakeAllowGuard extends RouteGuard {
  const FakeAllowGuard();

  @override
  bool evaluate() => true;
}

/// Always-blocking [RouteGuard], for tests.
class FakeDenyGuard extends RouteGuard {
  const FakeDenyGuard();

  @override
  bool evaluate() => false;
}

/// Async, always-allowing [RouteGuard], for tests.
class FakeAsyncAllowGuard extends RouteGuard {
  const FakeAsyncAllowGuard();

  @override
  Future<bool> evaluate() async => true;
}

/// Async, always-blocking [RouteGuard], for tests.
class FakeAsyncDenyGuard extends RouteGuard {
  const FakeAsyncDenyGuard();

  @override
  Future<bool> evaluate() async => false;
}

/// Minimal, unguarded [VmRoute] for tests: renders [Text] with its own
/// [path] as content so widget tests can assert which screen resolved.
class FakeVmRoute extends VmRoute {
  const FakeVmRoute(this.path);

  @override
  final String path;

  @override
  String get location => path;

  @override
  Widget build(BuildContext context, GoRouterState state) => Text(path);
}

/// Guarded [VmRoute] for tests: blocked unless every guard in [guards]
/// allows, redirecting to [guardFallbackPath].
class FakeGuardedVmRoute extends VmRoute {
  const FakeGuardedVmRoute(
    this.path, {
    required this.guards,
    required this.guardFallbackPath,
  });

  @override
  final String path;

  @override
  final List<RouteGuard> guards;

  @override
  final String? guardFallbackPath;

  @override
  String get location => path;

  @override
  Widget build(BuildContext context, GoRouterState state) => Text(path);
}
