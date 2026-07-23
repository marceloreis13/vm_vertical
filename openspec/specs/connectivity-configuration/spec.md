## Purpose

Define how the consuming app configures and registers `vm_connectivity` via DI, the adapter feeding `vm_network`'s connectivity gate, and the standalone example.

## Requirements

### Requirement: Injected configuration object

The module SHALL define a `VmConnectivityConfig` carrying the `ConnectivitySource` to use
(real or fake) and any optional tuning such as a debounce duration for rapid transitions. The
module SHALL NOT hard-code the source or read ambient global state; all configuration SHALL be
received from the consuming app.

#### Scenario: Config supplies the source

- **WHEN** an app constructs a `VmConnectivityConfig` with a chosen `ConnectivitySource`
- **THEN** the observable state SHALL be driven by exactly that source

#### Scenario: No concrete source hard-coded

- **WHEN** the module source is inspected
- **THEN** it SHALL not instantiate a concrete platform source outside of the injectable default wiring

### Requirement: Single DI registration entry point

The barrel SHALL expose one registration function (GetIt + Injectable convention) that
receives the `VmConnectivityConfig` from the consuming app and registers the repository and
`ConnectivityCubit`. Consumers SHALL resolve the Cubit and repository from the container by
their public types.

#### Scenario: Registration wires the observable state

- **WHEN** the app calls the registration function with a valid config
- **THEN** the container SHALL resolve the `ConnectivityCubit` backed by the configured source

#### Scenario: Config supplied by app, not the module

- **WHEN** registration is invoked
- **THEN** the config SHALL be taken from the passed parameter, not from module-internal constants

### Requirement: vm_network gate adapter

The module SHALL provide an adapter that maps `ConnectivityState.isOnline` onto the
`vm_network` connectivity gate abstraction, so an app can feed connectivity into the network
offline policy without `vm_network` importing `vm_connectivity`. The adapter SHALL expose an
online signal that emits `true` while `Online` and `false` while `Offline`.

#### Scenario: Adapter reflects state on the gate

- **WHEN** the connectivity state transitions between `Online` and `Offline`
- **THEN** the adapter's online signal SHALL emit `true` and `false` respectively, matching `isOnline`

#### Scenario: No reverse dependency

- **WHEN** the dependency graph is inspected
- **THEN** `vm_network` SHALL NOT depend on `vm_connectivity`; only the app wires the adapter into the network gate

### Requirement: Standalone visual example

The module SHALL ship an `example/` app that compiles and runs without depending on any app
under `apps/`, with its screens built from `vm_storyboard` components. It SHALL use a fake
`ConnectivitySource` that toggles between online and offline and SHALL reflect each change in
the UI, including the offline banner appearing and disappearing.

#### Scenario: Fake source toggles reflected in UI

- **WHEN** the user toggles the fake source between online and offline in the example
- **THEN** the example SHALL update the displayed state and show or hide the offline banner accordingly
