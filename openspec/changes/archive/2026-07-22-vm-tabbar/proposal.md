## Why

Apps in the monorepo need a bottom-tab navigation shell where each tab keeps its own
navigation stack and scroll/state when the user switches away and back, but there is no
shared component for it. `vm_navigation` today concatenates flat `List<RouteBase>` and
has no branch/shell concept, so state-preserving tabs (go_router's
`StatefulShellRoute.indexedStack`) cannot be expressed. This change delivers `vm_tabbar`:
a declarative, app-configured tab shell that renders the bar, and extends `vm_navigation`
with the minimal typed shell/branch abstraction it builds on.

## What Changes

- **Extend `vm_navigation`** with a typed stateful-shell abstraction (`VmShellRoute` +
  `VmBranch`) wrapping go_router's `StatefulShellRoute.indexedStack`. It exposes a single
  `RouteBase` (usable in `buildVmRouter`'s existing `moduleRouteLists`), owns per-branch
  state preservation via `IndexedStack`, hands the `StatefulNavigationShell` to an
  injected shell-view builder, and resolves deep links to the branch that matches the
  incoming location. `vm_navigation` gains no dependency on `vm_tabbar`.
- **New `packages/vm_tabbar` module** following the standard scaffold (barrel, `lib/src/`,
  `example/`, three test kinds, `resolution: workspace`).
- **Declarative tab configuration** — a `VmTab` value object (icon, label, the branch its
  content lives in, and an optional reactive badge source) plus an injected style/tokens
  object. The module references no concrete screen and no vendor design system; the app
  supplies both the tabs and the branch route lists.
- **`VmTabBarCubit`** — owns the selected-tab index and per-tab badge state, delegates
  selection to `StatefulNavigationShell.goBranch`, and emits a state consumed by the bar.
  Switching tabs preserves each branch's stack (no rebuild of inactive branches).
- **`VmTabBar` view** — the bottom navigation bar widget rendering tabs, active state, and
  badges, styled entirely from the injected tokens (no hard dependency on `vm_storyboard`;
  the app maps storyboard theme → tab tokens).
- **Reactive badges** — each tab may take a `Listenable`/`ValueListenable` so counts update
  at runtime without re-supplying the whole config.
- **Standalone `example/`** — an app with 3 mock tabs, a live badge, and demonstrable state
  preservation when alternating tabs; any missing generic UI is promoted to `vm_storyboard`.

## Capabilities

### New Capabilities
- `shell-routing`: `vm_navigation` typed `VmShellRoute`/`VmBranch` over
  `StatefulShellRoute.indexedStack` — per-branch state preservation, injected shell-view
  builder receiving the `StatefulNavigationShell`, deep-link resolution to the matching
  branch, and aggregation as a `RouteBase` with no module coupling.
- `tab-configuration`: the declarative, app-injected contract — `VmTab` (icon, label,
  branch, reactive badge), the ordered tab list, and the injected style tokens; the module
  knows no concrete screens or design-system package.
- `tab-navigation`: `VmTabBarCubit` selection state and badge state, delegation to
  `goBranch`, and preservation of each tab's navigation stack across switches and deep links.
- `tab-bar-view`: the `VmTabBar` bottom-bar widget — rendering tabs, active tab, and badges
  from injected tokens, with golden coverage of the bar.
- `tabbar-example`: the standalone `example/` app (3 mock tabs, live badge, state
  preservation) that compiles and runs the module in isolation.

### Modified Capabilities
<!-- No existing spec's requirements change: shell-routing is additive to vm_navigation and
     route-registration's flat-list contract is untouched. -->

## Impact

- **New package**: `packages/vm_tabbar` (+ `example/`), added to the pub workspace and the
  single lockfile; `docs/` updated per the living-docs convention.
- **`packages/vm_navigation`**: additive `VmShellRoute`/`VmBranch` API exported from the
  barrel; no change to `buildVmRouter`'s signature or the flat-list route-registration
  contract. No breaking changes.
- **Dependencies**: `vm_tabbar` depends on `vm_navigation` (shell/branches) and `flutter`;
  it does **not** depend on `vm_storyboard` (style is injected). Apps wire storyboard →
  tokens and supply per-tab branch route lists.
