## ADDED Requirements

### Requirement: Pluggable analytics provider port

The module SHALL define an `AnalyticsProvider` port mirroring the tracking operations
(`logEvent`, `setUserProperty`, `screenView`, `setUserId`, `reset`). Any number of
concrete providers SHALL be registrable without changing the `AnalyticsTracker` or its
call sites. Each provider SHALL be responsible for translating an `AnalyticsEvent` into
its own SDK representation.

#### Scenario: Adding a provider does not change call sites

- **WHEN** an app registers an additional provider
- **THEN** existing `AnalyticsTracker` call sites SHALL remain unchanged and the new provider SHALL start receiving calls

### Requirement: Multiplexation to N providers

The `AnalyticsTracker` SHALL fan out every tracking call to all registered providers.
With zero registered providers, calls SHALL be safe no-ops.

#### Scenario: Event delivered to all providers

- **WHEN** `logEvent` is called with three providers registered
- **THEN** all three providers SHALL each receive the same event

#### Scenario: No providers registered is a safe no-op

- **WHEN** a tracking call is made with no providers registered
- **THEN** the call SHALL complete without error and do nothing

### Requirement: Fire-and-forget delivery with per-provider error isolation

Tracking calls SHALL be fire-and-forget (returning `Future<void>`). A failure raised by
one provider SHALL be caught and isolated so it neither prevents delivery to the other
providers nor propagates to the call site. Isolated failures SHALL be reported through the
debug logging seam.

#### Scenario: One failing provider does not block others

- **WHEN** `logEvent` is called and one of several providers throws
- **THEN** the remaining providers SHALL still receive the event and the call site SHALL NOT observe an exception

#### Scenario: Isolated failure is logged

- **WHEN** a provider throws during a tracking call
- **THEN** the error SHALL be caught and reported via the debug logging seam rather than rethrown

### Requirement: Built-in noop provider

The module SHALL ship a `noop` provider that accepts every call and does nothing, for
standalone runs and tests.

#### Scenario: Noop discards all calls

- **WHEN** any tracking call reaches the `noop` provider
- **THEN** it SHALL complete successfully without side effects

### Requirement: Built-in observable debug provider

The module SHALL ship a `debug` provider that logs every tracking call via
`dart:developer` (a seam earmarked for a future `vm_logging`) and exposes an observable
record of received calls (buffer/stream) so a UI can display them on-screen.

#### Scenario: Debug provider logs calls

- **WHEN** a tracking call reaches the `debug` provider
- **THEN** it SHALL emit a developer-log entry describing the call

#### Scenario: Debug provider exposes calls for inspection

- **WHEN** the example app subscribes to the `debug` provider's observable record
- **THEN** it SHALL receive each tracked event/screen/property in order for on-screen rendering
