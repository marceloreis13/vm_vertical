## Purpose

Define how the consuming app configures and registers the notifications module via DI, and the standalone example that demonstrates it.

## Requirements

### Requirement: Injected configuration

The module SHALL expose a `VmNotificationsConfig` carrying the concrete provider, the
`NotificationRouter`, the optional `enabled` gate, and default channel settings, supplied by
the consuming app; no vendor key or app-specific value SHALL live in the module.

#### Scenario: App supplies configuration

- **WHEN** the app builds `VmNotificationsConfig` with a provider, a tap router, an optional
  gate, and channel defaults
- **THEN** the module uses exactly those values and contains no hard-coded provider, route,
  flag, or channel of its own

#### Scenario: Optional fields default safely

- **WHEN** the app omits the optional `enabled` gate
- **THEN** the module defaults it to always-on and still registers successfully

### Requirement: Single DI registration entry point

The module SHALL expose one registration function (GetIt + Injectable) that receives
`VmNotificationsConfig` and registers the facade and its dependencies.

#### Scenario: One call wires the module

- **WHEN** the app calls the module's single registration function with its config
- **THEN** `NotificationService` and its port bindings resolve from GetIt, and no other
  module setup is required

### Requirement: Standalone example app

The module SHALL ship a standalone `example/` app (built with `vm_storyboard`) that
schedules a local notification and simulates an incoming push via the `fake` provider, and
on tap routes to a target screen through an injected `NotificationRouter`.

#### Scenario: Example schedules a local and simulates a push

- **WHEN** the example runs and the user schedules a local notification and simulates a push
- **THEN** the local notification is recorded/shown and the simulated push appears via the
  fake provider, using only the module's public API

#### Scenario: Example routes on tap

- **WHEN** the user taps the simulated notification in the example
- **THEN** the injected `NotificationRouter` navigates to the target screen, demonstrating
  the payload→route flow without the module depending on `vm_navigation`
