## ADDED Requirements

### Requirement: Vendor-agnostic tracking interface

The module SHALL expose a single `AnalyticsTracker` interface as the only tracking API
consumers depend on. It SHALL provide `logEvent`, `setUserProperty`, `screenView`,
`setUserId`, and `reset`. No method signature, return type, or exported symbol SHALL
reference a vendor SDK type (e.g. Firebase Analytics or Amplitude types).

#### Scenario: Public API free of vendor types

- **WHEN** a consumer imports `package:vm_analytics/vm_analytics.dart`
- **THEN** no exported symbol SHALL reference a vendor SDK type, and swapping providers SHALL NOT change any call site

#### Scenario: Module emits without knowing the vendor

- **WHEN** a feature module calls `logEvent` through the injected `AnalyticsTracker`
- **THEN** it SHALL compile and run without importing or depending on any provider SDK

### Requirement: AnalyticsEvent value object

The module SHALL define an immutable `AnalyticsEvent` value object carrying a `name` and a
typed `parameters` map (`Map<String, Object?>`). Two `AnalyticsEvent` instances with equal
name and parameters SHALL be equal. `logEvent` SHALL accept an `AnalyticsEvent`.

#### Scenario: Value equality by name and parameters

- **WHEN** two `AnalyticsEvent` instances are built with the same name and equal parameters
- **THEN** they SHALL compare as equal

#### Scenario: logEvent accepts the value object

- **WHEN** a consumer builds an `AnalyticsEvent` and passes it to `logEvent`
- **THEN** the tracker SHALL accept it and forward it for delivery

### Requirement: Provider-agnostic event-name validation

The `AnalyticsEvent` name SHALL be validated at construction against a provider-agnostic
naming convention: snake_case, a bounded maximum length, and an allowed character set.
An invalid name SHALL be rejected at construction time rather than silently forwarded.

#### Scenario: Valid snake_case name accepted

- **WHEN** an `AnalyticsEvent` is constructed with a name like `checkout_started`
- **THEN** construction SHALL succeed

#### Scenario: Invalid name rejected at construction

- **WHEN** an `AnalyticsEvent` is constructed with a name that violates the convention (e.g. spaces, camelCase, or over the length limit)
- **THEN** construction SHALL fail (assertion/error) and the event SHALL NOT be forwarded to any provider

### Requirement: User property and identity lifecycle

The tracker SHALL support setting named user properties (`setUserProperty(name, value)`),
associating a user identity (`setUserId(id)`, where a null id clears it), and clearing all
identity/session state on logout (`reset`). Each of these SHALL be multiplexed to every
registered provider like other tracking calls.

#### Scenario: Set user property fans out to providers

- **WHEN** `setUserProperty` is called
- **THEN** every registered provider SHALL receive the property

#### Scenario: Reset clears identity across providers

- **WHEN** `reset` is called (e.g. on logout)
- **THEN** every registered provider SHALL be instructed to clear the current user identity and session state
