/// vm_navigation: a typed, injectable wrapper over go_router. Each
/// module/feature declares its own routes as a `List<RouteBase>`; the app
/// concatenates the activated modules' lists into one router. A generic
/// guard contract (no dependency on `vm_auth`/`vm_config`) resolves through
/// go_router's `redirect`, and a `BuildContext`-free navigator service lets
/// Cubits navigate directly.
library;

export 'src/di/vm_navigation_registration.dart';
export 'src/guards/domain/route_guard.dart';
export 'src/navigation/domain/vm_navigator_service.dart';
export 'src/presentation/demo/demo_session_cubit.dart';
export 'src/presentation/demo/vm_navigation_demo_app.dart';
export 'src/routing/data/vm_router_builder.dart';
export 'src/routing/domain/vm_branch.dart';
export 'src/routing/domain/vm_route.dart';
export 'src/routing/domain/vm_shell_route.dart';
