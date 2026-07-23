## 1. vm_navigation shell-routing extension

- [x] 1.1 Add `VmBranch` (wraps a module's `List<RouteBase>`) in `vm_navigation/lib/src/routing/domain/`
- [x] 1.2 Add `VmShellRoute` building `StatefulShellRoute.indexedStack` from an ordered `List<VmBranch>` + injected `shellBuilder(BuildContext, GoRouterState, StatefulNavigationShell)`, returning a single `RouteBase`
- [x] 1.3 Export `VmShellRoute`/`VmBranch` from the `vm_navigation.dart` barrel; confirm `buildVmRouter` signature unchanged
- [x] 1.4 Unit/widget tests: branch aggregation without coupling, per-branch state preservation, shell view receives the shell, deep link resolves to the owning branch
- [x] 1.5 Update `docs/` for the new `vm_navigation` shell API

## 2. vm_tabbar module scaffold

- [x] 2.1 Scaffold `packages/vm_tabbar` (barrel `lib/vm_tabbar.dart`, `lib/src/`, `example/`, `resolution: workspace`) per module-scaffold conventions
- [x] 2.2 Add dependencies: `vm_navigation`, `flutter`, `bloc`/`flutter_bloc`, `get_it`, `injectable`, `freezed`; wire into the workspace lockfile
- [x] 2.3 Confirm no dependency on `vm_storyboard` in `pubspec.yaml`

## 3. Domain (tab-configuration)

- [x] 3.1 `VmBadge` Freezed VO (count or dot)
- [x] 3.2 `VmTab` VO: icon, label, branch reference, optional `ValueListenable<VmBadge?>` badge source
- [x] 3.3 `VmTabBarStyle` (colors, icon/label styles, badge style, elevation, height) + default derived from `ThemeData`
- [x] 3.4 `VmTabBarState` Freezed state (selected index + per-tab current badges)
- [x] 3.5 `VmTabbarConfig` (ordered `List<VmTab>` + `VmTabBarStyle`)

## 4. Presentation — selection (tab-navigation)

- [x] 4.1 `VmTabBarCubit`: seed index from `StatefulNavigationShell.currentIndex`, `select(i)` → `goBranch` (re-tap on active → branch root)
- [x] 4.2 Reconcile index with the shell so deep links / external `goBranch` update the active tab
- [x] 4.3 Subscribe to each tab's badge `Listenable`, fold into `VmTabBarState`, release subscriptions on `close()`

## 5. Presentation — view (tab-bar-view)

- [x] 5.1 `VmTabBar` widget: one item per `VmTab` (icon+label), active-tab styling from state, tap → `select`
- [x] 5.2 Render badges (count/dot) from the injected `VmTabBarStyle`; none when absent
- [x] 5.3 `VmTabShellScaffold` (shellBuilder target) composing `VmTabBar` + the shell body
- [x] 5.4 `registerVmTabbar(GetIt, VmTabbarConfig)` DI entry point (GetIt + Injectable)

## 6. Tests

- [x] 6.1 Unit tests: `VmTabBarCubit` selection, re-tap-to-root, shell reconciliation, badge folding + subscription teardown
- [x] 6.2 Widget tests: tab switch and state preservation; tap invokes selection; deep link sets active tab
- [x] 6.3 Golden test: `VmTabBar` in isolation with fixed style, active index, and a badge

## 7. Standalone example (tabbar-example)

- [x] 7.1 `example/` app with 3 mock tabs, each bound to its own mock branch via `VmShellRoute`
- [x] 7.2 One tab with a live (incrementing) badge
- [x] 7.3 State-preservation demo (scroll/push a sub-route, switch, return)

## 8. Docs & wrap-up

- [x] 8.1 Update `docs/` (index + module doc) per living-docs convention
- [x] 8.2 Run `dart format` + `dart analyze` + full test suite (unit/widget/golden) for `vm_tabbar` and `vm_navigation`
