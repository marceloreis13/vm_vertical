import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// The convention every module/feature follows to expose its routes: a
/// plain function or static method returning its own `List<RouteBase>`
/// (typically `[for (final route in _routes) route.toRouteBase()]`), with
/// no reference to any other module's routes or to the app's router
/// instance. `vm_navigation` needs no special type for this — a bare
/// `List<RouteBase>` already is one.
///
/// Builds the app's single [GoRouter] by concatenating the route lists of
/// every module the app has activated. Modules stay decoupled: none is
/// aware which other modules are present, and removing a module from
/// [moduleRouteLists] removes only its routes from the result.
GoRouter buildVmRouter({
  required List<List<RouteBase>> moduleRouteLists,
  required GlobalKey<NavigatorState> navigatorKey,
  String initialLocation = '/',
}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialLocation,
    routes: [for (final routes in moduleRouteLists) ...routes],
  );
}
