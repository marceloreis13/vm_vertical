## Why

Apps and modules in the monorepo need to record product analytics (events, screen
views, user properties), but there is no shared tracking layer yet. Without one, every
consumer would bind directly to a vendor SDK (Firebase Analytics, Amplitude, …), leaking
that SDK into call sites and making a provider swap a cross-cutting rewrite. This change
delivers `vm_analytics`: a provider-agnostic tracking abstraction where apps inject the
concrete providers and keys, and modules emit events through one interface without knowing
the vendor.

## What Changes

- New `packages/vm_analytics` module following the standard scaffold (barrel, `lib/src/`,
  `example/`, three test kinds, `resolution: workspace`).
- **`AnalyticsTracker` interface** — the single API consumers depend on:
  `logEvent(AnalyticsEvent)`, `setUserProperty`, `screenView`, plus identity lifecycle
  `setUserId` and `reset` (logout). No vendor SDK type appears in the public API.
- **`AnalyticsEvent` value object** — a lightweight VO carrying a validated `name`
  (provider-agnostic naming convention: snake_case, length/charset limits) and a typed
  `parameters` map. It is the home of the event-naming convention; modules build typed
  factory constructors over it and providers translate it to their SDK.
- **Pluggable providers + multiplexation** — an `AnalyticsProvider` port; the tracker
  fans out every call to N registered providers. Delivery is **fire-and-forget**
  (`Future<void>`): a failing provider is caught and isolated (logged via the debug seam)
  and never breaks the other providers or the call site.
- **Built-in `noop` and `debug` providers** — `noop` for standalone/tests; `debug` logs
  via `dart:developer` (seam earmarked for a future `vm_logging`) and exposes an
  observable event buffer/stream so the example can render events on-screen.
- **Automatic screen tracking via `vm_navigation`** — `vm_analytics` depends on
  `vm_navigation` and ships a `NavigatorObserver` wired through the router config so
  route changes emit `screenView` automatically, out of the box; a manual `screenView`
  remains available.
- **Injected configuration** — `VmAnalyticsConfig` (the list of concrete providers,
  their keys, and screen-tracking toggle) supplied by the consuming app through a single
  DI registration entry point (GetIt + Injectable). No vendor key or app-specific value
  lives in the module.
- **Standalone `example/`** — a visual app (built with `vm_storyboard`) that dispatches
  events, sets user properties/identity, and navigates between screens, rendering the
  emitted events live via the `debug` provider on-screen. Any missing generic UI
  component is promoted to `vm_storyboard`.
- Living docs: register `vm_analytics` in `docs/` per project rule.

## Capabilities

### New Capabilities
- `analytics-tracker`: the `AnalyticsTracker` interface (`logEvent`, `setUserProperty`,
  `screenView`, `setUserId`, `reset`) and the `AnalyticsEvent` value object with its
  provider-agnostic name validation and typed parameters — the vendor-free contract
  consumers depend on.
- `analytics-providers`: the pluggable `AnalyticsProvider` port, fan-out multiplexation
  to N providers with fire-and-forget per-provider error isolation, and the built-in
  `noop` and `debug` providers (the latter observable for on-screen inspection).
- `screen-tracking`: automatic screen tracking through `vm_navigation` via a
  `NavigatorObserver`, plus the manual `screenView` path and screen-naming convention.
- `analytics-configuration`: the injected `VmAnalyticsConfig`, the single DI registration
  entry point, and the standalone visual `example/`.

### Modified Capabilities
<!-- None. This is a new module; no existing spec requirements change. -->

## Impact

- New package `packages/vm_analytics`; added to the root `workspace:` list in `pubspec.yaml`.
- New **hard dependency on `vm_navigation`** (for automatic screen tracking): any app or
  module that uses `vm_analytics` transitively requires `vm_navigation`.
- Dev deps: `build_runner`, `freezed`, `json_serializable`, `injectable_generator`,
  `mocktail` (fake providers for multiplexation/mapping unit tests).
- Logging of provider failures uses `dart:developer` via a seam, to be re-homed onto
  `vm_logging` (a later change) when it exists.
- The `example/` depends on `vm_storyboard`; generic UI components missing from the design
  system may be added to `packages/vm_storyboard` as part of this change.
- `docs/` index updated to include the new module.
- Base (Propose 1) monorepo conventions consumed. Concrete vendor providers (Firebase,
  Amplitude, …) are **out of scope**; this change ships only `noop` and `debug`. Dashboards
  and data analysis are out of scope.
