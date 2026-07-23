import '../../routing/domain/vm_route.dart';

/// Injectable, `BuildContext`-free navigation over typed routes. Resolved
/// via GetIt, so Cubits and other non-widget code can navigate without
/// holding or receiving a `BuildContext` — see `navigator-service`.
abstract class VmNavigatorService {
  /// Replaces the current location with [route.location].
  void go(VmRoute route);

  /// Pushes [route.location] onto the navigation stack.
  void push(VmRoute route);

  /// Replaces the top of the navigation stack with [route.location].
  void replace(VmRoute route);

  /// Pops the current route, optionally returning [result] to the caller.
  void pop<T extends Object?>([T? result]);
}
