import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:vm_navigation/vm_navigation.dart';

import '../tabbar/screen/vm_tab_shell_scaffold.dart';
import 'demo_routes.dart';

/// Entry point of the `vm_tabbar` visual example: three mock tabs (Home,
/// Search, Profile), each bound to its own branch via `VmShellRoute`, a
/// live badge on Profile, and a state-preservation demo on Home (see
/// `tabbar-example`). Lives in `lib/`, not `example/`, so any app can embed
/// it directly (see `docs/module-scaffold.md`); `example/` is only a thin
/// shell that calls `registerVmTabbarDemo` and runs this app.
class VmTabbarDemoApp extends StatefulWidget {
  const VmTabbarDemoApp({this.getIt, super.key});

  /// Defaults to [GetIt.instance]; overridable for tests/embedding apps
  /// with a scoped container.
  final GetIt? getIt;

  @override
  State<VmTabbarDemoApp> createState() => _VmTabbarDemoAppState();
}

class _VmTabbarDemoAppState extends State<VmTabbarDemoApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final shellRoute = VmShellRoute(
      branches: [
        VmBranch(routes: demoHomeBranchRoutes()),
        VmBranch(routes: demoSearchBranchRoutes()),
        VmBranch(routes: demoProfileBranchRoutes(getIt: widget.getIt)),
      ],
      shellBuilder: (context, state, shell) =>
          VmTabShellScaffold(shell: shell, getIt: widget.getIt),
    );
    _router = GoRouter(
      initialLocation: '/home',
      routes: [shellRoute.toRouteBase()],
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'vm_tabbar example',
      routerConfig: _router,
    );
  }
}
