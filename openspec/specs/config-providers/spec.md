## Purpose

Define the pluggable, pull-based remote config provider port, refresh semantics, failure isolation, and the built-in local and static-map providers.

## Requirements

### Requirement: Pluggable pull-based remote provider port
The module SHALL define a `RemoteConfigProvider` port that consumers implement to bind a
concrete remote source. The port SHALL be pull-based: it SHALL expose a `fetch()` operation
that returns the current remote key/value snapshot (or a `ConfigFailure`). The module SHALL
NOT import any concrete remote SDK; providers translate their SDK to the port.

#### Scenario: App binds a concrete source through the port
- **WHEN** an app implements `RemoteConfigProvider` over its remote source and injects it
- **THEN** the module fetches through the port without referencing the app's SDK

### Requirement: refresh() returns a typed Result
The module SHALL expose `refresh()` that invokes the remote provider's `fetch()`, updates
the resolved snapshot, and returns `Result<Unit, ConfigFailure>`. On success it SHALL return
success after the new snapshot is applied and change events emitted.

#### Scenario: Successful refresh applies the snapshot
- **WHEN** `refresh()` is called and the provider returns a snapshot
- **THEN** it returns success and subsequent reads reflect the new remote values

#### Scenario: Refresh reports failure without mutating reads
- **WHEN** `refresh()` is called and the provider's `fetch()` fails
- **THEN** it returns a `ConfigFailure` and reads continue to serve the prior snapshot,
  cache, or defaults

### Requirement: Fetch-failure isolation and fallback
A failing remote `fetch()` SHALL be caught and isolated: it SHALL NOT propagate as an
exception to the caller and SHALL NOT clear previously resolved values. The isolated failure
SHALL be reported through the logging seam. After a failure the reader SHALL keep serving the
last good snapshot, then cache, then defaults.

#### Scenario: Provider throws during fetch
- **WHEN** the remote provider throws inside `fetch()`
- **THEN** the module catches it, reports it via the seam, and the app keeps running on
  cache/defaults

### Requirement: Built-in local provider
The module SHALL ship a built-in `local` provider that contributes no remote values, so the
reader serves only injected defaults (and cache, if any). It SHALL be the inert default for
tests and standalone use.

#### Scenario: Local provider serves defaults only
- **WHEN** the module is configured with the `local` provider and no cache
- **THEN** every read returns its inline default

### Requirement: Built-in observable static-map provider
The module SHALL ship a built-in `static-map` provider backed by an in-memory key/value map
that can be mutated at runtime. Mutating the map and refreshing SHALL update resolved values
and emit change events, letting an example toggle flags without a real vendor SDK.

#### Scenario: Runtime mutation reflects after refresh
- **WHEN** a value in the `static-map` provider is changed and `refresh()` runs
- **THEN** the reader resolves the new value and emits a change event for that key
