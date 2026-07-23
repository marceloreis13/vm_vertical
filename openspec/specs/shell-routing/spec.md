## Purpose

Define `vm_navigation`'s typed stateful shell route built from go_router branches, preserving per-branch state and delegating chrome rendering to an injected builder.

## Requirements

### Requirement: Typed stateful shell over go_router branches

`vm_navigation` SHALL provide a typed `VmShellRoute` built from an ordered list of
`VmBranch`, where each `VmBranch` carries a module's own `List<RouteBase>`. `VmShellRoute`
SHALL produce a single `RouteBase` backed by go_router's `StatefulShellRoute.indexedStack`,
usable directly in `buildVmRouter`'s existing `moduleRouteLists`. No branch SHALL reference
another branch's or module's routes.

#### Scenario: Shell aggregates branches as one RouteBase

- **WHEN** an app builds a `VmShellRoute` from `[VmBranch(routesA), VmBranch(routesB)]` and
  includes its `RouteBase` in `buildVmRouter`'s `moduleRouteLists`
- **THEN** the resulting `GoRouter` resolves routes from both branches, and neither branch's
  code imports or references the other branch's routes

#### Scenario: Shell coexists with flat module routes

- **WHEN** `moduleRouteLists` contains both a `VmShellRoute` `RouteBase` and other modules'
  flat `List<RouteBase>`
- **THEN** all routes resolve correctly and `buildVmRouter`'s signature is unchanged

### Requirement: Per-branch state preservation

`VmShellRoute` SHALL preserve the navigation stack and widget state of every branch across
switches, using `IndexedStack` semantics so inactive branches remain mounted and are not
rebuilt when another branch is active.

#### Scenario: Switching branches keeps state

- **WHEN** the user is on branch 0 with a scrolled list / pushed sub-route, switches to
  branch 1, then returns to branch 0
- **THEN** branch 0 is shown in its prior state (same stack and scroll position) without
  being rebuilt from its root

### Requirement: Injected shell-view builder

`VmShellRoute` SHALL accept a shell-view builder `(BuildContext, GoRouterState,
StatefulNavigationShell)` and delegate rendering of the surrounding chrome to it, passing
the live `StatefulNavigationShell`. `vm_navigation` SHALL NOT render any tab bar itself and
SHALL NOT depend on `vm_tabbar` or `vm_storyboard`.

#### Scenario: Shell view receives the navigation shell

- **WHEN** the router resolves a location inside the shell
- **THEN** the injected builder is invoked with the current `StatefulNavigationShell`
  (exposing `currentIndex` and `goBranch`) as the surrounding view around the active branch

### Requirement: Deep link resolves to the matching branch

Navigating to a location that belongs to branch *k* SHALL make the `StatefulNavigationShell`
report `currentIndex == k` without any custom URL parsing in the shell.

#### Scenario: Deep link selects the owning branch

- **WHEN** the app navigates (deep link or programmatic) to a location registered under
  branch 2
- **THEN** the shell activates branch 2 and `StatefulNavigationShell.currentIndex` is 2
