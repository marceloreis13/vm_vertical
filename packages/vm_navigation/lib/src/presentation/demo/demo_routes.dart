import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../guards/domain/route_guard.dart';
import '../../routing/domain/vm_route.dart';
import 'demo_session_cubit.dart';
import 'demo_session_guard.dart';
import 'screen/demo_cubit_nav_screen.dart';
import 'screen/demo_home_screen.dart';
import 'screen/demo_login_screen.dart';
import 'screen/demo_protected_screen.dart';

/// Fades between demo screens using vm_storyboard's motion tokens —
/// `vm_navigation`'s optional theme/transition integration (see
/// `navigation-example`); the module core never depends on vm_storyboard.
Page<void> _fadeTransitionPage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  final motion = context.vmTokens.motion;
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: motion.medium,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: motion.curve),
          child: child,
        ),
  );
}

/// Screen 1: local in-memory logged-in/out toggle, and entry points to the
/// other two demo screens.
class DemoHomeRoute extends VmRoute {
  const DemoHomeRoute();

  static const routePath = '/';

  @override
  String get path => routePath;

  @override
  String get location => routePath;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DemoHomeScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _fadeTransitionPage(context, state, build(context, state));
}

/// Screen 2 (blocked outcome): shown when `DemoProtectedRoute`'s guard
/// fails and redirects here.
class DemoLoginRoute extends VmRoute {
  const DemoLoginRoute();

  static const routePath = '/login';

  @override
  String get path => routePath;

  @override
  String get location => routePath;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DemoLoginScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _fadeTransitionPage(context, state, build(context, state));
}

/// Screen 2 (allowed outcome): protected by [DemoSessionGuard], redirects to
/// [DemoLoginRoute] while the session toggle is off.
class DemoProtectedRoute extends VmRoute {
  const DemoProtectedRoute();

  static const routePath = '/protected';

  @override
  String get path => routePath;

  @override
  String get location => routePath;

  @override
  List<RouteGuard> get guards => [
    DemoSessionGuard(GetIt.instance<DemoSessionCubit>()),
  ];

  @override
  String? get guardFallbackPath => DemoLoginRoute.routePath;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DemoProtectedScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _fadeTransitionPage(context, state, build(context, state));
}

/// Screen 3: navigation triggered from `DemoNavigationCubit`, with no
/// `BuildContext`, via the navigator service.
class DemoCubitNavRoute extends VmRoute {
  const DemoCubitNavRoute();

  static const routePath = '/cubit-nav';

  @override
  String get path => routePath;

  @override
  String get location => routePath;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DemoCubitNavScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _fadeTransitionPage(context, state, build(context, state));
}

/// The example's route list, built through the same module route-list +
/// aggregation pattern any consuming app follows (see `route-registration`).
List<RouteBase> vmNavigationDemoRoutes() => [
  const DemoHomeRoute().toRouteBase(),
  const DemoLoginRoute().toRouteBase(),
  const DemoProtectedRoute().toRouteBase(),
  const DemoCubitNavRoute().toRouteBase(),
];
