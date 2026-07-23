## Purpose

Define the injected tap-to-route seam and the optional enable gate, both kept free of dependencies on `vm_navigation` and `vm_config`.

## Requirements

### Requirement: Injected tap-to-route seam

The module SHALL expose a `NotificationRouter` callback contract
(`NotificationPayload → Future<void>`) that the app injects, and the facade SHALL invoke it
when a notification is tapped; the module SHALL NOT depend on `vm_navigation` nor reference
the app's routes.

#### Scenario: Tap routes through the injected handler

- **WHEN** a notification is tapped and a `NotificationRouter` is configured
- **THEN** the facade invokes the handler with the tapped `NotificationPayload`, letting the
  app map it to a destination and navigate

#### Scenario: Module has no navigation dependency

- **WHEN** inspecting `vm_notifications`
- **THEN** its `pubspec.yaml` does not depend on `vm_navigation` and no module code imports
  or references the app's route types

#### Scenario: Faulty handler is isolated

- **WHEN** the injected `NotificationRouter` throws
- **THEN** the error is caught and isolated (logged via the debug seam) and notification
  handling continues without crashing

### Requirement: Optional enable gate seam

The module SHALL accept an optional injected `enabled` predicate (defaulting to always-on)
and SHALL check it before scheduling or handling notifications; the module SHALL NOT depend
on `vm_config`.

#### Scenario: Gate defaults to enabled

- **WHEN** no `enabled` predicate is injected
- **THEN** the module behaves as always enabled and schedules/handles notifications normally

#### Scenario: Gate disables notifications

- **WHEN** an injected `enabled` predicate returns `false`
- **THEN** scheduling and tap handling are short-circuited and no notification is scheduled
  or routed

#### Scenario: Module has no config dependency

- **WHEN** inspecting `vm_notifications`
- **THEN** its `pubspec.yaml` does not depend on `vm_config`; the app owns wiring the gate to
  any flag source
