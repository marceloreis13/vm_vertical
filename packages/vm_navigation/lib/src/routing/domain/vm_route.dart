import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../guards/domain/route_guard.dart';

/// Base contract for a module-declared, typed route.
///
/// A subclass carries its own typed fields (path parameters) and knows how
/// to turn itself into both a go_router registration entry ([toRouteBase],
/// via [path], a template like `/users/:id`) and a concrete navigation
/// target ([location], e.g. `/users/5`, built from this instance's field
/// values). Modules never reference another module's [VmRoute] subclass or
/// the app's router instance — see `route-registration`.
abstract class VmRoute {
  const VmRoute();

  /// The path template used for go_router registration, e.g. `/users/:id`.
  String get path;

  /// The concrete location this instance points to, built by substituting
  /// this instance's field values into [path]. Used by `VmNavigatorService`
  /// and irrelevant to registration (where only [path] and [toRouteBase]
  /// matter).
  String get location;

  /// Guards evaluated (logical AND) before this route resolves. Empty by
  /// default — most routes are unguarded.
  List<RouteGuard> get guards => const [];

  /// The route navigated to when any guard in [guards] fails. Required
  /// whenever [guards] is non-empty.
  String? get guardFallbackPath => null;

  /// Builds the screen for this route from its resolved go_router state.
  Widget build(BuildContext context, GoRouterState state);

  /// The go_router [Page] for this route. Defaults to a [MaterialPage]
  /// wrapping [build]; override to customize the transition (e.g. a fade
  /// sourced from vm_storyboard's motion tokens) without `vm_navigation`
  /// itself depending on vm_storyboard — see `navigation-example`.
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage<void>(child: build(context, state));

  /// The go_router entry for this route: [buildPage] wired as the page
  /// builder, and — when [guards] is non-empty — a `redirect` that resolves
  /// guards in order and sends navigation to [guardFallbackPath] on the
  /// first failure. Allowed routes redirect to nothing (`null`) and build
  /// normally; no external URI/deep-link parsing is performed anywhere in
  /// this resolution (see `conditional-redirect`).
  RouteBase toRouteBase() {
    return GoRoute(
      path: path,
      redirect: guards.isEmpty ? null : _resolveRedirect,
      pageBuilder: buildPage,
    );
  }

  Future<String?> _resolveRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    for (final guard in guards) {
      final allowed = await guard.evaluate();
      if (!allowed) {
        assert(
          guardFallbackPath != null,
          '$runtimeType declares guards but no guardFallbackPath',
        );
        return guardFallbackPath;
      }
    }
    return null;
  }
}
