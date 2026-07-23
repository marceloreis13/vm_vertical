## ADDED Requirements

### Requirement: Cubit-owned tab selection delegating to the shell

`vm_tabbar` SHALL provide a `VmTabBarCubit` that owns the selected-tab index and emits a
`VmTabBarState`. Selecting a tab SHALL delegate to the injected
`StatefulNavigationShell.goBranch`, treating a re-tap on the active tab as a request to
return that branch to its root. The Cubit SHALL NOT re-implement state preservation.

#### Scenario: Selecting a tab switches branch

- **WHEN** `VmTabBarCubit.select(2)` is called
- **THEN** the shell activates branch 2 and the emitted `VmTabBarState.index` is 2

#### Scenario: Re-tapping the active tab returns to its root

- **WHEN** the active branch has a pushed sub-route and its tab is tapped again
- **THEN** the shell pops that branch back to its root location while staying on the same tab

### Requirement: Index reconciled with the navigation shell

`VmTabBarCubit` SHALL seed its index from `StatefulNavigationShell.currentIndex` and stay
reconciled with it, so navigation originating outside the bar (deep link or programmatic
`goBranch`) is reflected as the active tab. The shell is authoritative.

#### Scenario: Deep link updates the active tab

- **WHEN** the app navigates by URL to a location under branch 1
- **THEN** the active tab becomes tab 1 and `VmTabBarState.index` is 1

### Requirement: State preserved across tab switches

Switching tabs via the Cubit SHALL preserve each branch's navigation stack and widget state
(no rebuild of an inactive branch), consistent with the shell's `IndexedStack` behavior.

#### Scenario: Returning to a tab restores its state

- **WHEN** the user pushes a sub-route on tab 0, switches to tab 1, then back to tab 0
- **THEN** tab 0 shows its previously pushed sub-route and scroll position, not its root

### Requirement: Reactive per-tab badges

A `VmTab` MAY carry a `Listenable`/`ValueListenable` badge source; `VmTabBarCubit` SHALL
subscribe to it and fold current badge values into `VmTabBarState`, updating without the app
re-supplying configuration. The Cubit SHALL release badge subscriptions on close.

#### Scenario: Badge updates live

- **WHEN** a tab's badge source emits a new count while the shell is mounted
- **THEN** the emitted `VmTabBarState` reflects the new badge value without reconfiguring
  the tab list

#### Scenario: Subscriptions released on dispose

- **WHEN** the `VmTabBarCubit` is closed
- **THEN** it unsubscribes from every tab's badge source (no lingering listeners)
