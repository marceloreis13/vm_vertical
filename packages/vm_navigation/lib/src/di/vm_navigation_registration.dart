import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import '../navigation/data/vm_go_router_navigator_service.dart';
import '../navigation/domain/vm_navigator_service.dart';

/// Single registration entry point for `vm_navigation`. Creates the root
/// [GlobalKey&lt;NavigatorState&gt;] shared by [VmNavigatorService] and the app's
/// `GoRouter` (via `buildVmRouter(navigatorKey: ...)`), and registers the
/// service in [getIt]. Returns the key so the app can pass the very same
/// instance when building its router — required for the service to resolve
/// the correct navigator.
GlobalKey<NavigatorState> registerVmNavigationModule(GetIt getIt) {
  final navigatorKey = GlobalKey<NavigatorState>();
  getIt.registerSingleton<GlobalKey<NavigatorState>>(navigatorKey);
  getIt.registerSingleton<VmNavigatorService>(
    VmGoRouterNavigatorService(navigatorKey),
  );
  return navigatorKey;
}
