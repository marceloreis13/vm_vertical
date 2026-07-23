## Context

`vm_core` is a modular Flutter monorepo ("Lego board"): apps compose reusable `vm_*`
packages on demand. Base (Propose 1) established the conventions — Clean Architecture +
feature-first, barrel-only public API, DI via GetIt + Injectable with config injected by
the consuming app, and a standalone runnable `example/` per module. `vm_navigation`,
`vm_network`, `vm_storage`, `vm_localization`, and `vm_storyboard` already exist.

`vm_analytics` is an infrastructure module: a provider-agnostic tracking abstraction so no
consumer binds to a vendor SDK. Apps inject the concrete providers and keys; modules emit
events through one interface. The architecture memory earmarks `Result`/`Failure`/`VMModule`
for a future `vm_foundation`, but analytics delivery is fire-and-forget, so this module does
not surface a `Result` at its tracking call sites.

Constraints: barrel-only public surface (no vendor type leaks); config never hard-coded;
per-provider failures isolated; delivery non-blocking for callers.

## Goals / Non-Goals

**Goals:**
- One `AnalyticsTracker` interface consumed by 2+ modules/apps; swapping/adding a provider
  never changes a call site.
- Fan-out to N providers with per-provider error isolation — one bad provider never breaks
  the others or the caller.
- An `AnalyticsEvent` value object that owns the provider-agnostic naming convention and
  stays decoupled from any vendor schema.
- Automatic screen tracking through `vm_navigation`, with a manual escape hatch.
- Built-in `noop` and observable `debug` providers; a visual `example/` that renders events
  on-screen with no real vendor SDK.

**Non-Goals:**
- Concrete vendor providers (Firebase, Amplitude, …) — apps implement `AnalyticsProvider`.
- Dashboards, querying, or data analysis.
- A full `vm_logging` integration (later change); logging uses `dart:developer` via a seam.
- Consent/GDPR gating and offline event queuing/batching (possible future changes).

## Decisions

### `AnalyticsTracker` interface + `AnalyticsProvider` port, mirrored operations
The public `AnalyticsTracker` (`logEvent`, `setUserProperty`, `screenView`, `setUserId`,
`reset`) is the only type consumers depend on. An `AnalyticsProvider` port declares the same
operations; the tracker's job is validation + multiplexation, the provider's job is SDK
translation. *Alternative:* let consumers hold provider lists directly — rejected; it leaks
fan-out and vendor concerns into call sites.

### `AnalyticsEvent` as a validating value object (naming convention lives here)
`logEvent(AnalyticsEvent)` instead of `logEvent(String, Map)`. The VO validates `name`
against a provider-agnostic convention (snake_case, bounded length, allowed charset) at
construction, carries a typed `parameters` map, and has value equality (Freezed). Modules add
typed factory constructors (`AnalyticsEvent.checkoutStarted(...)`) over it; providers map it
to their SDK. *Alternatives:* a sealed union with one case per event — rejected, every new app
event would edit the module, breaking "modules emit without changing the core"; a raw
name+map — rejected, the naming convention would be documentation only, unvalidated.

### Fire-and-forget delivery with per-provider isolation
Tracking calls return `Future<void>`. The tracker awaits each provider inside its own
try/catch so a throwing provider is caught, reported via the debug seam, and never aborts the
fan-out or reaches the caller. This matches how analytics is consumed (callers don't branch on
tracking outcomes) and keeps one misbehaving SDK from taking down others. *Alternative:*
return `Result<Unit, Failure>` like `vm_network` — rejected as atypical for analytics and it
would force handling at every call site.

### Automatic screen tracking via a `vm_navigation` `NavigatorObserver`
`vm_analytics` takes a hard dependency on `vm_navigation` and ships an
`AnalyticsRouteObserver` registered through the router config; each route change derives a
screen name and calls `screenView`. Auto-tracking is toggled in `VmAnalyticsConfig`, and a
manual `screenView(name)` covers flows the observer can't name. *Trade-off:* the hard
dependency makes `vm_navigation` mandatory for any `vm_analytics` consumer — accepted per the
brief's "integrates with vm_navigation" and the chosen design. *Alternative:* an optional
observer seam with no pubspec dependency — rejected in favor of out-of-the-box auto-tracking.

### Injected `VmAnalyticsConfig` + single DI entry point
One Injectable registration function receives `VmAnalyticsConfig` (providers, keys,
screen-tracking toggle) and registers the tracker, providers, and observer. No vendor key
lives in the module. *Alternative:* per-provider registration calls — rejected; the module
must expose exactly one entry point per convention.

### `debug` provider is observable for the example
The `debug` provider logs via `dart:developer` and also exposes a broadcast stream / buffer of
received calls, letting the `example/` render them live on-screen. `noop` is the inert default
for tests/standalone. *Alternative:* have the example subclass a provider itself — rejected;
an observable debug provider is reusable and demonstrates the real seam.

## Risks / Trade-offs

- **Hard `vm_navigation` dependency couples the two modules** → accepted per the chosen design;
  auto-tracking is the headline feature. If a consumer ever needs analytics without navigation,
  a later change can extract the observer behind an optional seam.
- **Naming convention may be stricter or looser than a specific vendor** (e.g. Firebase's 40-char
  snake_case limit) → the VO enforces a reasonable provider-agnostic superset; providers may
  further sanitize/truncate when mapping to their SDK.
- **Fire-and-forget hides delivery failures** → mitigated by routing isolated failures through
  the debug seam (and, later, `vm_logging`) and by the observable debug provider in dev.
- **No batching/offline queue** → out of scope now; providers wrap their SDK's own buffering,
  and a queuing layer can be added later without changing the interface.
- **`vm_logging` does not exist yet** → the debug/error seam uses `dart:developer`, isolated so
  the later swap to `vm_logging` is a re-home, mirroring `vm_network`.

## Migration Plan

New additive module; no existing behavior changes. Add `packages/vm_analytics` to the root
`workspace:`, implement the capabilities, ship `example/`, register the module in `docs/`.
Rollback is removal of the package and its workspace entry. Vendor providers are adopted later
by implementing `AnalyticsProvider` in the app, with no change to `vm_analytics`.

## Open Questions

- None blocking. Consent/GDPR gating, offline queuing/batching, and the `vm_logging` swap are
  deferred to future changes.
