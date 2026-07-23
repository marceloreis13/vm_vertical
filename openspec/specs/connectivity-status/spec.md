## Purpose

Define the injectable connectivity source abstraction, the sealed `ConnectivityState`, and the observable repository/Cubit that exposes connectivity transitions.

## Requirements

### Requirement: Injectable connectivity source abstraction

The module SHALL define an abstract `ConnectivitySource` that exposes the current OS
connection type and a stream of connection-type changes. The concrete implementation over
`connectivity_plus` SHALL live in `lib/src/` and SHALL NOT be exported from the barrel. The
source SHALL be injectable so a fake source can replace the real one without changing
consumers. Active internet-reachability probing is out of scope this iteration; the source
SHALL report only the OS-provided connection type.

#### Scenario: Concrete package hidden behind the barrel

- **WHEN** the module's public barrel is inspected
- **THEN** it SHALL export no `connectivity_plus` type and only the `ConnectivitySource` abstraction and domain types

#### Scenario: Source is injectable

- **WHEN** a consumer registers the module with a fake `ConnectivitySource`
- **THEN** the observable state SHALL be driven by that fake source and no real platform call SHALL occur

### Requirement: Sealed connectivity state with derived isOnline

The module SHALL model connectivity as a sealed `ConnectivityState` with exactly two cases:
`Online` carrying a `ConnectionType` (wifi, cellular, ethernet, and any other non-none type)
and `Offline`. It SHALL expose a derived `isOnline` that is `true` for `Online` and `false`
for `Offline`. A connection type of none SHALL map to `Offline`.

#### Scenario: Non-none type maps to Online

- **WHEN** the source reports a wifi, cellular, or ethernet connection
- **THEN** the state SHALL be `Online` carrying the corresponding `ConnectionType` and `isOnline` SHALL be `true`

#### Scenario: None maps to Offline

- **WHEN** the source reports no connection
- **THEN** the state SHALL be `Offline` and `isOnline` SHALL be `false`

### Requirement: Observable state via repository and Cubit

The module SHALL provide a repository that observes the `ConnectivitySource` stream and maps
it to `ConnectivityState`, and a `ConnectivityCubit` that emits the current state and every
subsequent transition so any module or the UI can watch it. The Cubit SHALL emit an initial
state derived from the source's current value on creation.

#### Scenario: Transitions are emitted

- **WHEN** the source moves from a connected type to none and back
- **THEN** the Cubit SHALL emit `Offline` then `Online` in order, reflecting each transition

#### Scenario: Initial state on subscription

- **WHEN** a consumer subscribes to the Cubit
- **THEN** it SHALL receive the current `ConnectivityState` derived from the source's present value before any further change
