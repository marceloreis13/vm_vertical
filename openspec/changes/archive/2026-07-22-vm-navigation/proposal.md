## Why

Apps in the monorepo need routing, but each activates a different subset of `vm_*`
modules and none should know about the others' routes. Without a shared layer, every
app would hand-wire `go_router`, duplicate guard/redirect logic, and let Cubits reach
into `BuildContext` just to navigate. This change delivers `vm_navigation`: a typed,
injectable wrapper over `go_router` that lets modules declare routes independently, the
app aggregate them with zero coupling, and Cubits navigate without a `BuildContext`.

## What Changes

- New `packages/vm_navigation` module following the standard scaffold (barrel,
  `lib/src/`, `example/`, three test kinds, `resolution: workspace`).
- **Typed route registration**: each module/feature exposes a function/class returning
  `List<RouteBase>` built from its own typed route definitions (path + typed params).
  The consuming app concatenates the lists of all modules it activated when building the
  single `GoRouter` instance — no module references another's routes.
- **Generic guard contract**: a single injectable predicate abstraction (sync or async,
  returning bool/`Result`) used uniformly for any gate a route needs — auth state,
  feature flags, or anything else. `vm_navigation` has **no dependency on `vm_auth` or
  vm_config`**; the app supplies the concrete predicate (today a mock, later backed by a
  real module) at registration time.
- **Conditional redirect**: guard failures resolve through `go_router`'s `redirect`,
  sending the user to a configured fallback route. No external URI/deep-link parsing
  (App Links/Universal Links) — that is explicitly out of scope, reserved for a future
  `vm_deeplink` module.
- **Navigator service**: an injectable (GetIt) service exposing `push`/`pop`/`replace`/
  `go`, accepting typed routes, backed internally by a `GlobalKey<NavigatorState>` (or
  `StatefulNavigationShell` where relevant) so Cubits and other non-widget code can
  navigate without a `BuildContext`.
- **Optional `vm_storyboard` integration**: page transitions and route-level theming can
  consume `vm_storyboard` tokens/transitions when the app has that module active; the
  dependency is optional, not required.
- **Standalone `example/`** with three screens: a screen with a local in-memory
  logged-in/out toggle (guard state, no `vm_auth`), a protected route that redirects to
  another screen when the guard fails, and a screen that triggers navigation from a Cubit
  through the Navigator service (no `BuildContext`).
- Living docs: register `vm_navigation` in `docs/` per project rule.

## Capabilities

### New Capabilities
- `route-registration`: the typed, per-module `List<RouteBase>` contract and the
  app-side aggregation pattern that lets N modules contribute routes with zero coupling
  between them.
- `route-guards`: the generic injectable guard/predicate contract (auth, feature flags,
  or any other gate) and its wiring into `go_router` redirect resolution.
- `conditional-redirect`: redirect behavior when a guard fails, including fallback route
  configuration; explicitly excludes external URI/deep-link parsing.
- `navigator-service`: the injectable, context-free navigation service
  (`push`/`pop`/`replace`/`go`) usable from Cubits and other non-widget code.
- `navigation-example`: the standalone `example/` demonstrating the three screens (guard
  toggle, protected/redirecting route, Cubit-driven navigation) and its `vm_storyboard`
  integration for transitions/theme when present.

### Modified Capabilities
<!-- None. This is a new module; no existing spec requirements change. -->

## Impact

- New package `packages/vm_navigation`; added to root `workspace:` list in
  `pubspec.yaml`.
- New third-party dependency: `go_router`. Dev deps as per module scaffold
  (`build_runner`, `freezed`, `json_serializable`, `injectable_generator`, `mocktail`)
  where applicable to route/guard models.
- Unit tests cover guard/redirect logic in isolation (fake predicates); widget tests
  cover navigation flows (guarded redirect, Cubit-driven navigation) against the
  in-package `example/` or test harness routes.
- `example/` optionally depends on `vm_storyboard` for transitions/theme; any missing
  generic UI component needed by the example may be promoted to `packages/vm_storyboard`.
- Depends on Base (Propose 1) monorepo conventions only. No dependency on `vm_auth` or
  `vm_config` — both are consumed later, by the apps that inject real guard predicates
  once those modules exist.
- `docs/` index updated to include the new module.
- **Out of scope**: tab UI (`vm_tabbar`, integrates but is not built here), external
  deep-link/URI-scheme parsing, and any real integration with `vm_auth`/`vm_config`.
