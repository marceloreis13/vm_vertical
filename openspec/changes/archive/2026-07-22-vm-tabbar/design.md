## Context

`vm_tabbar` must deliver a bottom-tab shell where each tab preserves its own navigation
stack and state. The idiomatic go_router mechanism for that is
`StatefulShellRoute.indexedStack`, which keeps every branch mounted in an `IndexedStack`
and exposes a `StatefulNavigationShell` (current index, `goBranch(i)`, per-branch state).

`vm_navigation` (see `packages/vm_navigation`) currently abstracts go_router behind
`VmRoute` and builds the app router via `buildVmRouter({ moduleRouteLists })`, which flat-
concatenates `List<RouteBase>`. There is **no** branch/shell type. Because a
`StatefulShellRoute` *is* a `RouteBase`, the flat aggregation can already carry a shell —
the missing piece is a typed, module-friendly way to *build* one. Per the brief's
integration mandate, that abstraction belongs in `vm_navigation`; `vm_tabbar` renders the
bar only.

Project constraints: Clean Architecture (presentation/domain/data), Cubit for state,
GetIt+Injectable DI, Freezed for models, one registration function per module receiving
injected config, barrel-only public API, and modules that compile standalone via
`example/`. `vm_navigation` deliberately avoids a hard dependency on `vm_storyboard`
(transitions injected); `vm_tabbar` follows the same rule for style.

## Goals / Non-Goals

**Goals:**
- Add a minimal typed `VmShellRoute` / `VmBranch` to `vm_navigation` over
  `StatefulShellRoute.indexedStack`, additive and non-breaking.
- `vm_tabbar` renders the bar and owns tab-selection + badge state (`VmTabBarCubit`),
  delegating actual navigation to the injected `StatefulNavigationShell`.
- Fully declarative, app-injected tab config; module knows no concrete screens.
- Style injected as tokens; no dependency on `vm_storyboard` from either module.
- Reactive per-tab badges via `Listenable`.
- Deep link to a branch's location selects the correct tab out of the box.
- Each module still compiles/runs standalone (`example/`).

**Non-Goals:**
- Screen logic inside tabs (owned by apps/features).
- Top tabs (`TabBar`/`TabBarView`), `NavigationRail`, or adaptive/responsive layouts.
- Nested/multi-level shells or per-branch independent `Navigator` keys beyond what
  `StatefulShellBranch` provides by default.
- Mapping `vm_storyboard` theme → tab tokens (that adapter lives in the consuming app).

## Decisions

**D1 — Shell abstraction lives in `vm_navigation` (`VmShellRoute` + `VmBranch`).**
`VmBranch` wraps a module's `List<RouteBase>` (a branch's routes). `VmShellRoute` takes an
ordered `List<VmBranch>` plus a `shellBuilder(BuildContext, GoRouterState,
StatefulNavigationShell)` and produces a single `RouteBase` via
`StatefulShellRoute.indexedStack`. The app drops that `RouteBase` into the existing
`moduleRouteLists`. *Why here, not in `vm_tabbar`:* keeps go_router hidden behind
`vm_navigation`'s abstraction (consistent with `VmRoute`), lets non-tabbar shells reuse it,
and avoids `vm_tabbar` importing go_router directly. *Alternative rejected:* `vm_tabbar`
builds the `StatefulShellRoute` itself — simpler but leaks go_router into `vm_tabbar` and
duplicates router concerns the navigation module already owns.

**D2 — `StatefulNavigationShell` is the source of truth for index + preservation;
`VmTabBarCubit` wraps it.** `IndexedStack` inside `StatefulShellRoute` already preserves
each branch. The Cubit does not re-implement preservation; it holds the selected index
(seeded from `shell.currentIndex`) and badge state, exposes `select(i)` →
`shell.goBranch(i, initialLocation: i == shell.currentIndex)` (tap-again returns to branch
root), and emits `VmTabBarState`. *Why:* satisfies the project's Cubit mandate and makes
badge/selection testable without a widget tree, while not fighting go_router. *Alternative
rejected:* rely on `StatefulNavigationShell` alone with no Cubit — fewer moving parts but
no Cubit seam for badges/tests and inconsistent with the codebase.

**D3 — Style is injected tokens, not `vm_storyboard`.** `VmTabBar` takes a
`VmTabBarStyle` (colors, icon/label styles, badge style, elevation, height). The app maps
its `vm_storyboard` theme into `VmTabBarStyle`. *Why:* mirrors `vm_navigation`'s
decoupling, keeps `vm_tabbar` compilable standalone, and prevents a hard module→module
design-system coupling. *Alternative rejected:* depend on `vm_storyboard` directly — matches
the brief's literal wording but couples the modules and breaks standalone builds.

**D4 — Reactive badges via `Listenable`.** `VmTab.badge` is an optional
`ValueListenable<VmBadge?>` (or `null`). `VmTabBarCubit` subscribes and folds badge values
into `VmTabBarState`, so counts update without re-supplying config. `VmBadge` is a small
Freezed VO (count or dot). *Alternative rejected:* static badge in config — simpler but no
live updates, which is the primary badge use case (unread counts).

**D5 — Deep link selects the tab automatically.** Because branches are real go_router
routes, navigating to a location under branch *k* makes `StatefulNavigationShell` report
`currentIndex == k`; the Cubit seeds/syncs from `shell.currentIndex` on build. No custom
URL parsing in `vm_tabbar`. This reuses `conditional-redirect`/`route-registration`
behavior already in `vm_navigation`.

**D6 — Layering & DI.** `vm_tabbar`: `domain` = `VmTab`, `VmBadge`, `VmTabBarStyle`,
`VmTabBarState`; `presentation` = `VmTabBarCubit`, `VmTabBar`, and a `VmTabShellScaffold`
(the `shellBuilder` target that composes `VmTabBar` + shell body). One registration
function `registerVmTabbar(GetIt, VmTabbarConfig)` where `VmTabbarConfig` carries the tab
list and style. The app builds the `VmShellRoute` from the same tab list's branches. Public
API exported only from `lib/vm_tabbar.dart`.

## Risks / Trade-offs

- **Duplicated index state (Cubit vs shell) drifting out of sync** → Treat `shell` as
  authoritative: Cubit seeds from `shell.currentIndex`, and the shell view rebuilds from
  the shell on branch changes so external navigation (deep link, `goBranch` elsewhere)
  reconciles the Cubit. Cover with a widget test that navigates by URL and asserts the
  active tab.
- **`vm_navigation` API surface growth** → Keep `VmShellRoute`/`VmBranch` minimal and
  additive; no change to `buildVmRouter` or `VmRoute`, so existing consumers are unaffected.
- **Injected-style boilerplate for apps** → Provide a sensible default `VmTabBarStyle` (from
  `ThemeData`) so apps can start without storyboard wiring; storyboard mapping stays optional.
- **Badge `Listenable` lifecycle leaks** → Cubit owns subscribe/unsubscribe in
  `close()`; example exercises a changing badge to prove teardown.
- **Golden fragility across platforms** → Pin font/loader per the `vm-testing` golden
  conventions; golden covers the bar view in isolation, not the whole shell.

## Open Questions

- None blocking. Adaptive layout (rail on wide screens) and top tabs are deferred
  (Non-Goals) and can be a follow-up change if needed.
