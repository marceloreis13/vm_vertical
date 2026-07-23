## Context

The monorepo needs a shared routing layer. The brief (`briefs/5-vm-navigation.md`) asks
for typed routes, guards (auth/feature flags), basic deep link/redirect, and a
`BuildContext`-free navigator for Cubits, on top of `go_router`. It depends only on the
base monorepo conventions (Propose 1); `vm_auth` and `vm_storyboard` are listed as
optional integrations.

Two modules named as guard sources — `vm_auth` (brief 9) and `vm_config` (brief 10) —
do not exist yet in this leva. Rather than block or half-integrate, this change defines
one **generic guard contract** shared by both use cases; concrete auth/feature-flag
logic is supplied by the app later, when those modules land. This mirrors the isolation
strategy `vm_network`/`vm_storage` used for `Result`/failure types: define the seam now,
plug in the real implementation later without touching `vm_navigation`.

`vm_storyboard` already exists in `packages/`, so the optional transition/theme
integration in `example/` is real, not speculative.

## Goals / Non-Goals

**Goals:**
- Typed route registration: each module/feature exposes a `List<RouteBase>`; the app
  concatenates lists from all active modules into one `GoRouter`.
- A generic, injectable guard/predicate contract reused for any gate (auth, feature
  flags, anything else), with no dependency on `vm_auth`/`vm_config`.
- Conditional redirect: `go_router`'s `redirect` resolves failed guards to a configured
  fallback route.
- An injectable Navigator service (`push`/`pop`/`replace`/`go`) over typed routes,
  usable from Cubits without a `BuildContext`.
- Optional `vm_storyboard` integration for page transitions/theme.
- Standalone `example/`: 3 screens — guard toggle (in-memory), a protected/redirecting
  route, and Cubit-driven navigation via the Navigator service.

**Non-Goals:**
- External URI/deep-link parsing (App Links/Universal Links, custom schemes) — reserved
  for a future `vm_deeplink` module.
- Any real `vm_auth`/`vm_config` integration — only the generic contract they will
  plug into later.
- Tab UI (`vm_tabbar` integrates with this module but is not built here).
- Nested/shell routing beyond what the example needs to prove the guard + navigator
  patterns (no attempt at a general-purpose shell-route abstraction).

## Decisions

- **One generic guard contract for auth and feature flags.** Both are "does this route
  resolve or redirect" questions; a single `RouteGuard` (sync/async predicate returning
  bool or a `Result`) covers both without inventing two near-identical abstractions.
  *Alternative:* separate `AuthGuard`/`FeatureFlagGuard` types — rejected as premature
  differentiation with no behavioral difference at this layer; the app names/composes
  guards meaningfully when it injects them.

- **Route registration as `List<RouteBase>` factories, not a runtime registry.** Each
  module exposes a plain function/class returning its routes; the app imports and
  concatenates them explicitly when building `GoRouter`. *Alternative:* a GetIt-backed
  registry where modules self-register at startup — rejected: it hides the aggregation
  point, adds startup-order sensitivity, and buys nothing over explicit composition for
  a compile-time-known set of modules per app.

- **Guard failures resolve through `go_router` `redirect`, not route-level widgets.**
  Keeps guard logic declarative and centralized in router config rather than scattered
  as per-screen conditional builds. Fallback route is passed alongside each guard.

- **Navigator service backed by a `GlobalKey<NavigatorState>` (or the root
  `StatefulNavigationShell` where present), registered once in GetIt.** Cubits call the
  service, never `BuildContext`; the service resolves the current `NavigatorState`/
  `GoRouter` instance internally. *Alternative:* passing `BuildContext` through Cubit
  constructors — rejected; it is exactly the coupling the brief asks to remove.

- **Deep link scope limited to conditional redirect.** "Redirect básico" in the brief is
  read narrowly: reacting to guard state when a route is entered, not parsing external
  URIs. Broader deep-linking is deferred to the Tier 3 `vm_deeplink` module named in
  `briefs/0-index.md`.

- **`vm_storyboard` integration stays optional.** The module core has no hard dependency
  on it; `example/` uses it directly since it already exists, and transition/theme hooks
  are additive extension points, not required constructor parameters.

## Risks / Trade-offs

- **Generic guard contract may feel under-specified until `vm_auth`/`vm_config` exist**
  → mitigated by the standalone `example/`'s in-memory toggle, which exercises the full
  guard → redirect path end-to-end without a real auth backend.
- **Explicit route-list concatenation (vs. a registry) puts aggregation order in the
  app's hands** → acceptable and intentional: it keeps modules decoupled and the app's
  router composition traceable/debuggable at a single call site.
- **`GlobalKey<NavigatorState>`-based navigation can misbehave with nested navigators
  (shells/tabs)** → out of scope for this change's example (single root navigator); the
  service's contract is written so an app with nested shells can supply the appropriate
  key/context per navigator later without changing the public API.
- **No external deep-link parsing** → apps needing it today must handle URI-to-route
  mapping themselves until `vm_deeplink` ships; this is called out explicitly in scope
  docs so it is not mistaken for an oversight.
