import 'dart:async';

/// A generic, injectable gate for a route: sync or async, evaluating to
/// `true` (route resolves) or `false` (route is blocked; see
/// `conditional-redirect`). One contract for any condition — auth state,
/// feature flags, or anything else — so `vm_navigation` never depends on
/// `vm_auth`/`vm_config`. If the consuming app's own check naturally
/// returns a `Result`, adapt it to a bool at the call site (e.g.
/// `result.isSuccess`) before returning it here.
abstract class RouteGuard {
  const RouteGuard();

  /// Whether the route this guard protects may resolve.
  FutureOr<bool> evaluate();
}
