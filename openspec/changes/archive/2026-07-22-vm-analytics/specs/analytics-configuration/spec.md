## ADDED Requirements

### Requirement: Injected configuration

The module SHALL expose a `VmAnalyticsConfig` supplied by the consuming app, carrying the
list of concrete providers, their vendor keys, and the automatic screen-tracking toggle.
No vendor key or app-specific value SHALL be hard-coded inside the module.

#### Scenario: App supplies providers and keys

- **WHEN** an app constructs `VmAnalyticsConfig` with its chosen providers and keys and registers the module
- **THEN** the tracker SHALL multiplex to exactly those providers using the supplied configuration

#### Scenario: No hard-coded vendor configuration

- **WHEN** the module source is inspected
- **THEN** it SHALL contain no vendor key or app-specific endpoint; all such values SHALL arrive via `VmAnalyticsConfig`

### Requirement: Single DI registration entry point

The module SHALL expose exactly one registration function (GetIt + Injectable) that
receives `VmAnalyticsConfig` and registers the `AnalyticsTracker`, the configured
providers, and the screen-tracking observer for injection into apps and modules.

#### Scenario: One call wires the module

- **WHEN** an app calls the single registration function with its `VmAnalyticsConfig`
- **THEN** `AnalyticsTracker` SHALL be resolvable from the DI container and ready to use

### Requirement: Standalone visual example

The module SHALL include a runnable `example/` app, built with `vm_storyboard`
components, that dispatches events, sets user properties and identity, and navigates
between screens, rendering the emitted calls live via the `debug` provider on-screen.

#### Scenario: Example renders emitted events on-screen

- **WHEN** the example app dispatches an event or navigates
- **THEN** the corresponding call SHALL appear in the on-screen list fed by the `debug` provider

#### Scenario: Example runs standalone

- **WHEN** the example is run on its own
- **THEN** it SHALL work using only the built-in `debug`/`noop` providers, requiring no real vendor SDK or key
