import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../data/providers/debug_analytics_provider.dart';
import '../screen_tracking/analytics_route_observer.dart';
import 'analytics_demo_routes.dart';

/// Entry point of the `vm_analytics` visual example: two screens (home,
/// details) wired through a `GoRouter` with `AnalyticsRouteObserver`
/// registered as an `observers` entry — see `screen-tracking`. Lives in
/// `lib/`, not `example/`, so any app can embed it directly (see
/// `docs/module-scaffold.md`).
class AnalyticsDemoApp extends StatefulWidget {
  const AnalyticsDemoApp({required this.debugProvider, this.getIt, super.key});

  /// The [DebugAnalyticsProvider] instance the app wired into
  /// `VmAnalyticsConfig`, so the demo can render exactly what it received.
  final DebugAnalyticsProvider debugProvider;

  /// Defaults to [GetIt.instance]; overridable for tests/embedding apps
  /// with a scoped container.
  final GetIt? getIt;

  @override
  State<AnalyticsDemoApp> createState() => _AnalyticsDemoAppState();
}

class _AnalyticsDemoAppState extends State<AnalyticsDemoApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final container = widget.getIt ?? GetIt.instance;
    _router = GoRouter(
      observers: [container<AnalyticsRouteObserver>()],
      routes: analyticsDemoRoutes(debugProvider: widget.debugProvider),
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = (widget.getIt ?? GetIt.instance)<VmTheme>();
    return MaterialApp.router(
      title: 'vm_analytics example',
      theme: theme.light,
      darkTheme: theme.dark,
      routerConfig: _router,
    );
  }
}
