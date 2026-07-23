import 'package:go_router/go_router.dart';

/// One branch of a [VmShellRoute]: a module's own `List<RouteBase>`, kept
/// mounted (and state-preserved) independently of every other branch via
/// `StatefulShellRoute.indexedStack`'s `IndexedStack` semantics.
///
/// A branch never references another branch's or module's routes — the same
/// zero-coupling contract `vm_navigation`'s flat route-registration already
/// follows (see `route-registration`).
class VmBranch {
  const VmBranch({required this.routes});

  /// This branch's own routes, typically built the same way a flat module's
  /// routes are (`[for (final route in _routes) route.toRouteBase()]`).
  final List<RouteBase> routes;
}
