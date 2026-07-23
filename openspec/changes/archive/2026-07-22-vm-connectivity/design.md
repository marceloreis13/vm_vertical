## Context

`vm_core` is a modular Flutter monorepo ("Lego board"): apps compose reusable `vm_*`
packages on demand, with all config injected by the consuming app and each module runnable
standalone via `example/`. Base (Propose 1) established the conventions — Clean Architecture +
feature-first, barrel-only public API, DI via GetIt + Injectable, three test kinds. Today
`vm_storyboard`, `vm_network`, `vm_storage`, `vm_navigation`, and `vm_localization` exist;
`vm_foundation` does not, so shared primitives stay local per module.

`vm_connectivity` is an observability module: it turns the platform's connection status into
an injectable, observable state that any module or the UI can watch, and it wires that state
into `vm_network` so requests can pause and resume with connectivity. The brief's success
criterion is explicit: modules must react to offline **without coupling to the concrete
connectivity package**. That constraint shapes the whole design.

Constraints: barrel-only public surface; `connectivity_plus` hidden behind an abstraction;
config never hard-coded; `vm_network` must not depend on `vm_connectivity`.

## Goals / Non-Goals

**Goals:**
- An injectable `ConnectivitySource` over the OS connection type, with `connectivity_plus`
  hidden in `lib/src/` and never leaking through the barrel.
- A sealed `ConnectivityState` (`Online(type)` | `Offline`, derived `isOnline`) exposed via a
  `ConnectivityCubit` fed by a repository observing the source stream; source injectable
  (real/fake).
- A real bridge into `vm_network` that pauses/resumes requests on connectivity, with the
  dependency inverted so `vm_network` owns an abstract gate and never imports connectivity.
- An offline banner in `vm_connectivity`'s presentation, composed from `vm_storyboard`.
- A standalone `example/` with a fake source toggling online/offline reflected in the UI.

**Non-Goals:**
- Active "real internet reachability" probing (DNS/HTTP ping) — left as a documented seam for
  a later iteration; this iteration reports only the OS connection type.
- A complex offline sync/replay queue (explicitly out of scope in the brief; may become its
  own module).
- Creating `vm_foundation`; primitives stay local if needed.
- App-specific banner copy, endpoints, or presentation beyond what the example needs.

## Decisions

### `connectivity_plus` as the internal source, hidden behind `ConnectivitySource`
`connectivity_plus` is the de-facto Flutter package for OS connection type and exposes a
change stream out of the box. The public API is an abstract `ConnectivitySource` (current type
+ `Stream<ConnectionType>`); the `connectivity_plus`-backed implementation lives in `lib/src/`
and never appears in a public signature. *Alternative:* expose the package directly — rejected,
it would leak the transport across the barrel and violate the decoupling criterion.

### Sealed `ConnectivityState` with derived `isOnline`, not a bare bool
A sealed union `Online(ConnectionType)` | `Offline` keeps the type information the brief calls
out (wifi/cellular/ethernet) while a derived `isOnline` gives banner/consumers the simple
signal. `none` maps to `Offline`. Idiomatic Dart 3 (exhaustive `switch`). *Alternative:* a
plain `enum online/offline` — rejected, it discards connection type the brief mentions.

### Repository + Cubit as the observable seam
A repository maps the source stream to `ConnectivityState`; a `ConnectivityCubit` emits the
initial state and every transition. Cubit matches the project's state-management standard and
gives consumers a `BlocBuilder`/`context.watch` surface without exposing streams directly.

### Bridge with inverted dependency: gate lives in `vm_network`
The bridge is real this change, but `vm_network` must not depend on `vm_connectivity`. So
`vm_network` gains its **own** abstract connectivity gate (an online signal) plus an offline
request policy interceptor; `vm_connectivity` ships an **adapter** mapping
`ConnectivityState.isOnline` onto that gate; the app wires them in its composition root. This
keeps `vm_network` lower-level and dependency-free while still delivering pause/resume.
*Alternative:* have `vm_network` import `vm_connectivity` — rejected, it inverts the layering
and breaks the decoupling criterion. *Alternative:* seam only, no interceptor — rejected, the
user chose the real bridge this change.

### Offline policy holds requests with a bounded wait, fails typed
While offline, the interceptor holds outbound requests and resumes them when the gate goes
online, bounded by a configurable timeout; exceeding the bound completes with a typed
connectivity/offline `Failure` (consistent with `vm_network`'s never-raw-exception guarantee).
Backwards compatible: with no gate configured, the client behaves exactly as today.
*Alternative:* fail fast when offline — rejected, holding-and-resuming is the point of the
policy; fast-fail can still be expressed via a zero bound.

### Offline banner in `vm_connectivity`, composed from `vm_storyboard`
The banner is connectivity-specific composition, so it lives in `vm_connectivity`'s
presentation and watches the Cubit; it is built from `vm_storyboard` primitives/tokens, and any
genuinely generic missing primitive is promoted to `vm_storyboard` (same rule as the
`vm_network` example). *Alternative:* put the banner in `vm_storyboard` — rejected, it would
couple the design system to the offline concept.

### Example uses a fake source
The `example/` injects a fake `ConnectivitySource` with a manual toggle so online/offline (and
the banner) are demonstrated deterministically without airplane-mode gymnastics, and the same
fake backs the unit tests of state transitions.

## Risks / Trade-offs

- **Reverse dependency creeping in (vm_network importing connectivity)** → Enforce the gate
  abstraction in `vm_network`, keep the adapter in `vm_connectivity`, and add a dependency
  check; no `connectivity_plus`/`vm_connectivity` in `vm_network`'s pubspec.
- **`connectivity_plus` reports "connected" without real internet** → Accepted this iteration
  (reachability is a documented non-goal); the source contract is typed so a probing source can
  be added later without changing consumers.
- **Held requests could hang** → The offline policy bounds the wait and fails with a typed
  offline `Failure`; covered by a unit test.
- **Rapid online/offline flapping spams transitions** → Optional debounce in
  `VmConnectivityConfig` smooths bursts; default is no debounce to keep behavior obvious.
- **Promoting components to `vm_storyboard` widens blast radius** → Promote only genuinely
  generic pieces, golden-test them, and keep connectivity-specific wiring local.
- **Modifying `vm_network` risks regressions** → All additions are behind an optional gate;
  absent gate path is asserted identical to prior behavior by a test.

## Migration Plan

New additive module plus a backwards-compatible `vm_network` extension. Steps: scaffold
`packages/vm_connectivity`, add to root `workspace:`; implement source/state/repository/Cubit;
add the gate abstraction + offline policy interceptor to `vm_network` and the config fields;
add the adapter in `vm_connectivity`; build the offline banner and the fake-source example;
wire the example composition root; add unit/widget/golden tests; update `docs/`. Rollback =
remove the package and its workspace entry and drop the optional `vm_network` gate fields
(no consumer relies on them by default).

## Open Questions

- None blocking. Default offline-policy bound and whether debounce defaults on can be tuned as
  sensible defaults in `VmConnectivityConfig`/`VmNetworkConfig` and adjusted by consumers.
