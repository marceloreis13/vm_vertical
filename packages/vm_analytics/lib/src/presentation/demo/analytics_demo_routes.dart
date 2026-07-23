import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vm_navigation/vm_navigation.dart';

import '../../data/providers/debug_analytics_provider.dart';
import 'screen/analytics_demo_details_screen.dart';
import 'screen/analytics_demo_home_screen.dart';

/// Screen 1: dispatches sample events/properties/identity calls and links to
/// [AnalyticsDemoDetailsRoute]. `buildPage` sets an explicit [MaterialPage]
/// `name` (already snake_case) so `AnalyticsRouteObserver` has a screen name
/// to derive from — go_router's default `pageBuilder` leaves `name` unset.
class AnalyticsDemoHomeRoute extends VmRoute {
  const AnalyticsDemoHomeRoute({required this.debugProvider});

  static const routePath = '/';

  final DebugAnalyticsProvider debugProvider;

  @override
  String get path => routePath;

  @override
  String get location => routePath;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AnalyticsDemoHomeScreen(debugProvider: debugProvider);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage<void>(
        name: 'analytics_demo_home',
        child: build(context, state),
      );
}

/// Screen 2: reached by navigating, demonstrating automatic screen tracking.
class AnalyticsDemoDetailsRoute extends VmRoute {
  const AnalyticsDemoDetailsRoute();

  static const routePath = '/details';

  @override
  String get path => routePath;

  @override
  String get location => routePath;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AnalyticsDemoDetailsScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage<void>(
        name: 'analytics_demo_details',
        child: build(context, state),
      );
}

/// The example's route list, built through the same module route-list
/// pattern any consuming app follows (see `vm_navigation`'s
/// `route-registration`).
List<RouteBase> analyticsDemoRoutes({
  required DebugAnalyticsProvider debugProvider,
}) => [
  AnalyticsDemoHomeRoute(debugProvider: debugProvider).toRouteBase(),
  const AnalyticsDemoDetailsRoute().toRouteBase(),
];
