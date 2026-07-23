## Purpose

Define automatic screen-view tracking integrated with vm_navigation, plus the manual screenView call for flows not covered by the observer.

## Requirements

### Requirement: Automatic screen tracking via vm_navigation

The module SHALL provide a `NavigatorObserver` that integrates with `vm_navigation` and,
when wired through the router configuration, emits a `screenView` for each route change
without any per-screen call. Automatic screen tracking SHALL be toggleable through
configuration.

#### Scenario: Route change emits a screen view

- **WHEN** the observer is registered and the app navigates to a new route
- **THEN** the tracker SHALL receive a `screenView` for the destination screen, multiplexed to all providers

#### Scenario: Automatic tracking can be disabled

- **WHEN** automatic screen tracking is disabled in configuration
- **THEN** route changes SHALL NOT emit `screenView` and only manual calls SHALL be recorded

### Requirement: Manual screen view

The tracker SHALL expose a manual `screenView(name)` call for screens or flows not covered
by the observer. The screen name SHALL follow the same provider-agnostic naming convention
as event names.

#### Scenario: Manual screen view fans out

- **WHEN** `screenView` is called manually with a valid screen name
- **THEN** every registered provider SHALL receive the screen view

#### Scenario: Invalid screen name rejected

- **WHEN** `screenView` is called with a name that violates the naming convention
- **THEN** the call SHALL be rejected before reaching any provider
