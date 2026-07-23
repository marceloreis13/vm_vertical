# `vm_navigation`

Typed, injectable routing for the vm_core platform. Wraps `go_router`: each
module/feature declares its own routes as a `List<RouteBase>`, the app
concatenates the lists of every module it activates into one `GoRouter`, and
a generic guard contract resolves through `go_router`'s `redirect` — with no
dependency on `vm_auth` or `vm_config`. A `BuildContext`-free navigator
service lets Cubits navigate directly.

## Register at app startup

```dart
final navigatorKey = registerVmNavigationModule(getIt);

final router = buildVmRouter(
  moduleRouteLists: [
    myFeatureRoutes(),      // List<RouteBase> from one module
    anotherFeatureRoutes(), // ...from another; neither references the other
  ],
  navigatorKey: navigatorKey, // must be the key returned above
  initialLocation: '/',
);

MaterialApp.router(routerConfig: router, ...);
```

`registerVmNavigationModule` registers the `VmNavigatorService` in `getIt`
and returns the root `GlobalKey<NavigatorState>` the app must pass to
`buildVmRouter` — the service resolves navigation through that same key, so
using a different one breaks it.

## Declare a module's routes

Each route is a typed `VmRoute` subclass: a path template for registration,
a concrete `location` built from the instance's own fields, and the widget
to build.

```dart
class UserRoute extends VmRoute {
  const UserRoute({required this.id});

  final String id;

  @override
  String get path => '/users/:id'; // registration template

  @override
  String get location => '/users/$id'; // concrete navigation target

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      UserScreen(id: state.pathParameters['id']!);
}

List<RouteBase> myFeatureRoutes() => [const UserRoute(id: ':id').toRouteBase()];
```

The module exposes only this function — never a `GoRouter` instance, and
never another module's route classes. Removing a module from the app's
`moduleRouteLists` removes only its routes.

## Guard a route

Attach one or more `RouteGuard`s; all must pass (logical AND) or navigation
redirects to `guardFallbackPath`:

```dart
class ProfileRoute extends VmRoute {
  const ProfileRoute();

  @override
  String get path => '/profile';

  @override
  String get location => '/profile';

  @override
  List<RouteGuard> get guards => [_IsLoggedInGuard(authRepository)];

  @override
  String? get guardFallbackPath => '/login';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileScreen();
}

class _IsLoggedInGuard extends RouteGuard {
  const _IsLoggedInGuard(this._auth);
  final AuthRepository _auth;

  @override
  Future<bool> evaluate() async => _auth.currentUser != null;
}
```

`RouteGuard.evaluate()` is sync-or-async, returning a `bool`. `vm_navigation`
has no concept of auth or feature flags — the app supplies the concrete
predicate. If your own check naturally returns a `Result`, adapt it to a
`bool` (e.g. `result.isSuccess`) before returning it from the guard. No
external URI or deep-link parsing happens anywhere in this module; that is
reserved for a future `vm_deeplink` module.

## Navigate without a `BuildContext`

Resolve `VmNavigatorService` from `getIt` — useful from a Cubit, which
never touches `BuildContext`:

```dart
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._navigator) : super(const ProfileState.initial());
  final VmNavigatorService _navigator;

  void onSaved() => _navigator.go(const ProfileRoute());
}
```

`go`/`push`/`replace`/`pop` all accept a `VmRoute` instance (its `location`
drives the actual `go_router` call).

## Optional `vm_storyboard` integration

`VmRoute.buildPage` defaults to a plain `MaterialPage` wrapping `build` — no
`vm_storyboard` dependency required. Override it to customize the page
transition, e.g. a fade sourced from `vm_storyboard`'s motion tokens:

```dart
@override
Page<void> buildPage(BuildContext context, GoRouterState state) {
  final motion = context.vmTokens.motion;
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: build(context, state),
    transitionDuration: motion.medium,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: motion.curve),
          child: child,
        ),
  );
}
```

## State-preserving tab/branch shells

For a bottom-tab (or any stateful-shell) layout where each branch keeps its
own navigation stack and widget state, wrap go_router's
`StatefulShellRoute.indexedStack` with `VmShellRoute`/`VmBranch` instead of
reaching for go_router directly:

```dart
final shellRoute = VmShellRoute(
  branches: [
    VmBranch(routes: homeModuleRoutes()),   // List<RouteBase>, one per branch
    VmBranch(routes: searchModuleRoutes()),
    VmBranch(routes: profileModuleRoutes()),
  ],
  shellBuilder: (context, state, shell) => MyTabShell(shell: shell),
);

final router = buildVmRouter(
  moduleRouteLists: [
    [shellRoute.toRouteBase()], // a shell is just another RouteBase
    otherFlatModuleRoutes(),    // shells and flat modules coexist freely
  ],
  navigatorKey: navigatorKey,
);
```

`shellBuilder` receives the live `StatefulNavigationShell` (`currentIndex`,
`goBranch`) and renders the chrome around the active branch —
`vm_navigation` never renders a tab bar itself; that is `vm_tabbar`'s job
(see `docs/vm_tabbar.md`). Every branch stays mounted in an `IndexedStack`,
so switching branches never rebuilds an inactive one, and navigating to a
location owned by branch *k* makes `StatefulNavigationShell.currentIndex`
report `k` with no custom URL parsing anywhere in this module. No branch
references another branch's or module's routes, and `buildVmRouter`'s
signature is unchanged.

## Visual example

`packages/vm_navigation/example/` is a standalone Flutter app (no `apps/`
dependency) with three screens: a Home screen with a local in-memory
logged-in/out toggle, a protected route that redirects to a login screen
while logged out, and a screen whose button drives navigation from a Cubit
(`DemoNavigationCubit`) with no `BuildContext`. The demo (`VmNavigationDemoApp`
and its screens) lives in `lib/` and is exported by the barrel, so any app
can embed it directly via `package:vm_navigation/vm_navigation.dart` — the
`example/` app is only a thin shell that registers the module and runs it.
