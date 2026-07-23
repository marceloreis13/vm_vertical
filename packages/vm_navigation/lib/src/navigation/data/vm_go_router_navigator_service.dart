import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../routing/domain/vm_route.dart';
import '../domain/vm_navigator_service.dart';

/// [VmNavigatorService] backed by the single root
/// [GlobalKey&lt;NavigatorState&gt;] passed to `buildVmRouter`/`GoRouter`. Resolves
/// the current [GoRouter] through the key's `BuildContext` at call time, so
/// it always drives the router instance the app actually built — never a
/// stale reference.
class VmGoRouterNavigatorService implements VmNavigatorService {
  const VmGoRouterNavigatorService(this._navigatorKey);

  final GlobalKey<NavigatorState> _navigatorKey;

  BuildContext get _context {
    final context = _navigatorKey.currentContext;
    assert(
      context != null,
      'VmNavigatorService was used before the root navigator was built. '
      'Make sure buildVmRouter(navigatorKey: ...) uses the same key '
      'registered by registerVmNavigationModule.',
    );
    return context!;
  }

  @override
  void go(VmRoute route) => GoRouter.of(_context).go(route.location);

  @override
  void push(VmRoute route) =>
      unawaited(GoRouter.of(_context).push<Object?>(route.location));

  @override
  void replace(VmRoute route) =>
      unawaited(GoRouter.of(_context).replace<Object?>(route.location));

  @override
  void pop<T extends Object?>([T? result]) =>
      GoRouter.of(_context).pop<T>(result);
}
