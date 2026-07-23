import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../routing/data/vm_router_builder.dart';
import 'demo_routes.dart';

/// Entry point of the `vm_navigation` visual example: three screens (guard
/// toggle, protected/redirecting route, Cubit-driven navigation — see
/// `navigation-example`). Builds the app's single `GoRouter` via
/// `buildVmRouter`, reusing the `GlobalKey<NavigatorState>` registered by
/// `registerVmNavigationModule`. Lives in `lib/`, not `example/`, so any
/// app can embed it directly (see `docs/module-scaffold.md`).
class VmNavigationDemoApp extends StatefulWidget {
  const VmNavigationDemoApp({this.getIt, super.key});

  /// Defaults to [GetIt.instance]; overridable for tests/embedding apps
  /// with a scoped container.
  final GetIt? getIt;

  @override
  State<VmNavigationDemoApp> createState() => _VmNavigationDemoAppState();
}

class _VmNavigationDemoAppState extends State<VmNavigationDemoApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final container = widget.getIt ?? GetIt.instance;
    _router = buildVmRouter(
      moduleRouteLists: [vmNavigationDemoRoutes()],
      navigatorKey: container<GlobalKey<NavigatorState>>(),
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
      title: 'vm_navigation example',
      theme: theme.light,
      darkTheme: theme.dark,
      routerConfig: _router,
    );
  }
}
