# `vm_tabbar`

Declarative, app-configured bottom tab-bar shell for the vm_core platform.
Renders `VmTabBar` and owns tab-selection/badge state via `VmTabBarCubit`,
built on `vm_navigation`'s state-preserving `VmShellRoute`/`VmBranch` (see
`docs/vm_navigation.md`). The app supplies the ordered tab list (icon,
label, branch, optional reactive badge) and style tokens — `vm_tabbar` knows
no concrete screens and has **no dependency on `vm_storyboard`**.

## Register at app startup

```dart
registerVmNavigationModule(getIt); // vm_navigation's own registration

registerVmTabbar(
  getIt,
  VmTabbarConfig(
    tabs: [
      VmTab(icon: Icons.home, label: 'Home', branchIndex: 0),
      VmTab(icon: Icons.search, label: 'Search', branchIndex: 1),
      VmTab(
        icon: Icons.person,
        label: 'Profile',
        branchIndex: 2,
        badge: myUnreadCountNotifier, // ValueListenable<VmBadge?>, optional
      ),
    ],
    // style: myVmTabBarStyle, // optional; defaults to VmTabBarStyle.fromTheme
  ),
);
```

Nothing is hard-coded inside the module — the tab list and style always come
from the consuming app.

## Wire the shell into the router

Build the branches with `vm_navigation`'s `VmShellRoute`, pointing
`shellBuilder` at `VmTabShellScaffold`:

```dart
final shellRoute = VmShellRoute(
  branches: [
    VmBranch(routes: homeModuleRoutes()),
    VmBranch(routes: searchModuleRoutes()),
    VmBranch(routes: profileModuleRoutes()),
  ],
  shellBuilder: (context, state, shell) => VmTabShellScaffold(shell: shell),
);

final router = buildVmRouter(
  moduleRouteLists: [[shellRoute.toRouteBase()]],
  navigatorKey: navigatorKey,
);
```

`VmTabShellScaffold` resolves the app-registered `VmTabbarConfig` from
`getIt`, builds a `VmTabBarCubit` bound to the live `StatefulNavigationShell`,
and composes `VmTabBar` (bottom) with the shell's active branch body. Each
tab's `branchIndex` must match the position of its `VmBranch` in the same
order passed to `VmShellRoute`.

## Selection, re-tap and deep links

`VmTabBarCubit.select(i)` delegates to `StatefulNavigationShell.goBranch`;
re-tapping the already-active tab returns that branch to its root location.
The Cubit's index is reconciled with the shell on every rebuild, so a deep
link or a programmatic `goBranch` elsewhere in the app is reflected as the
active tab with no custom URL parsing in `vm_tabbar`.

## Reactive badges

A `VmTab.badge` is an optional `ValueListenable<VmBadge?>` — `count(n)` or
`dot()`. `VmTabBarCubit` subscribes on construction and folds every update
into `VmTabBarState.badges`, so a badge updates live without re-supplying
the tab list. Subscriptions are released in `close()`.

## Styling

`VmTabBar` renders exclusively from an injected `VmTabBarStyle` (colors,
icon/label typography, badge appearance, elevation, height). Omit `style` in
`VmTabbarConfig` to fall back to `VmTabBarStyle.fromTheme(Theme.of(context))`
— the module runs and looks reasonable with zero style wiring. An app using
`vm_storyboard` maps its own theme into a `VmTabBarStyle`; `vm_tabbar` never
imports `vm_storyboard`.

## Visual example

`packages/vm_tabbar/example/` is a standalone Flutter app (no `apps/`
dependency) with three mock tabs — Home (a scrolled list with a pushed
sub-route, demonstrating state preservation across tab switches), Search,
and Profile (showing a live, auto-incrementing badge). The demo
(`VmTabbarDemoApp`, `registerVmTabbarDemo`, and its screens) lives in `lib/`
and is exported by the barrel, so any app can embed it directly via
`package:vm_tabbar/vm_tabbar.dart` — `example/` is only a thin shell that
registers the module and runs it.
