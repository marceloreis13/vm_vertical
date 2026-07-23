## Why

Apps and modules in the monorepo have no shared, observable notion of network
connectivity, so any feature that must react to online/offline would poll the platform
itself and leak a concrete connectivity package across the codebase. This change delivers
`vm_connectivity`: a generic, injectable module that exposes online/offline as an
observable state any module or the UI can watch, plus a real (but decoupled) bridge into
`vm_network` so requests can pause and resume with connectivity.

## What Changes

- New `packages/vm_connectivity` module following the standard scaffold (barrel,
  `lib/src/`, standalone `example/`, three test kinds, `resolution: workspace`).
- **Connectivity detection** of the OS connection type (wifi / cellular / ethernet /
  none) via `connectivity_plus`, hidden behind an abstract `ConnectivitySource` that never
  leaks through the barrel (same pattern as Dio in `vm_network`). Active "real internet
  reachability" probing is **out of scope** this iteration and left as a documented seam.
- **Observable sealed state**: `ConnectivityState` = `Online(type)` | `Offline` with a
  derived `isOnline`, exposed via a `ConnectivityCubit` fed by a repository that observes
  the source's stream. The source is injectable (real or fake).
- **Injected configuration**: `VmConnectivityConfig` (connectivity source, optional
  policy/debounce) supplied by the consuming app through a single GetIt + Injectable
  registration entry point. Modules only observe the state.
- **Offline banner** widget living in `vm_connectivity`'s presentation layer, composed
  from `vm_storyboard` primitives/tokens and driven by the Cubit; it appears/disappears
  with the state. Only genuinely generic missing pieces are promoted to `vm_storyboard`.
- **Real bridge into `vm_network`, with inverted dependency to preserve decoupling**:
  `vm_network` gains its own abstract connectivity **gate** seam plus an **offline request
  policy** interceptor that holds requests while offline and resumes them when online.
  `vm_network` does **not** import `vm_connectivity`. `vm_connectivity` provides an adapter
  mapping `ConnectivityState.isOnline` onto that gate; the consuming app wires the two in
  its composition root. `VmNetworkConfig` gains an optional gate + offline policy.
- **Standalone `example/`**: a runnable app with a **fake source** toggling
  online/offline and reflecting it in the UI (banner appears/disappears), screens built
  with `vm_storyboard`.
- Living docs: register `vm_connectivity` in `docs/` per the project rule.

## Capabilities

### New Capabilities
- `connectivity-status`: the injected `ConnectivitySource` abstraction over the OS
  connection type, the sealed `ConnectivityState` (`Online(type)` | `Offline`, `isOnline`),
  the repository observing the stream, the `ConnectivityCubit`, and the state-transition
  behavior.
- `connectivity-configuration`: the injected `VmConnectivityConfig`, the single DI
  registration entry point, real/fake source injection, the `vm_network` gate adapter, and
  the standalone runnable `example/`.
- `offline-banner`: the offline banner widget in `vm_connectivity`'s presentation,
  driven by the Cubit and composed from `vm_storyboard`, with the storyboard promotion rule.
- `network-offline-policy`: `vm_network`'s own abstract connectivity **gate** seam and the
  offline request policy interceptor that holds requests while offline and resumes them when
  the online signal returns, without importing `vm_connectivity`.

### Modified Capabilities
- `network-configuration`: `VmNetworkConfig` gains an optional connectivity **gate** and
  offline request **policy**, wired into the client's interceptor chain.

## Impact

- New package `packages/vm_connectivity`; added to the root `workspace:` list in
  `pubspec.yaml`.
- New third-party dependency: `connectivity_plus` (inside `vm_connectivity` only). Dev
  deps: `build_runner`, `freezed`, `injectable_generator`, `bloc_test`, `mocktail`,
  `golden_toolkit` (or existing golden setup) for the three test kinds.
- `packages/vm_network` is modified additively: a new connectivity gate abstraction, an
  offline request policy interceptor, and optional `VmNetworkConfig` fields. No existing
  `vm_network` behavior changes when the gate is absent (backwards compatible).
- The `example/` depends on `vm_storyboard`; generic UI missing from the design system may
  be promoted to `packages/vm_storyboard` as part of this change.
- `Result`/`Failure` are used locally only if needed; `vm_foundation` does not exist yet.
- `docs/` index updated to include the new module.
