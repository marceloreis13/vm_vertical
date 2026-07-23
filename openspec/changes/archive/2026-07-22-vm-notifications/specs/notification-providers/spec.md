## ADDED Requirements

### Requirement: Pluggable push provider port

The module SHALL define a `PushProvider` port covering token lifecycle (current token and
token-change stream), foreground/background message reception, and tap events, such that a
concrete vendor implementation can be supplied without changing the facade or call sites.

#### Scenario: Swapping the push provider does not affect call sites

- **WHEN** the app injects a different `PushProvider` implementation
- **THEN** the `NotificationService` facade and every consumer of it compile and behave
  unchanged, with no call site referencing the concrete provider

#### Scenario: Provider surfaces token, messages, and taps

- **WHEN** a `PushProvider` implementation is registered
- **THEN** the facade obtains the token and token changes, the received-message stream, and
  the tap events through that port and nothing else

### Requirement: Pluggable local scheduler port

The module SHALL define a `LocalScheduler` port covering scheduling and cancellation of
local notifications and channel/category setup, such that a concrete implementation can be
supplied without changing the facade or call sites.

#### Scenario: Scheduling routes through the port

- **WHEN** the facade schedules or cancels a local notification
- **THEN** the operation is delegated to the injected `LocalScheduler` implementation, with
  no consumer referencing the concrete implementation

#### Scenario: Channels configured through the port

- **WHEN** the app provides default channel/category settings via configuration
- **THEN** the `LocalScheduler` registers those channels and scheduled notifications target
  them

### Requirement: Typed failure isolation

Provider operations that can fail SHALL be surfaced through a sealed
`NotificationFailure` via `Result`, and the facade SHALL catch provider exceptions and map
them to a failure rather than throwing into the call site.

#### Scenario: Provider throws during scheduling

- **WHEN** the underlying provider throws while scheduling a local notification
- **THEN** the facade returns a `Result` failure with a typed `NotificationFailure` and does
  not propagate the exception to the caller

#### Scenario: Message stream stays alive after a provider error

- **WHEN** the provider raises an error while delivering a message
- **THEN** the error is isolated (logged via the debug seam) and the message stream remains
  usable for subsequent notifications

### Requirement: Built-in in-memory fake provider

The module SHALL ship a single `FakeNotificationProvider` implementing both the
`PushProvider` and `LocalScheduler` ports in memory, able to record scheduled locals and
simulate an incoming push, for use by tests and the `example/` with no native plugin.

#### Scenario: Fake records scheduled locals

- **WHEN** a test schedules a local notification through the facade backed by the fake
- **THEN** the fake exposes the scheduled notification (and reflects cancellations) so the
  test can assert on it

#### Scenario: Fake simulates an incoming push

- **WHEN** a test or the example triggers the fake to deliver a simulated push
- **THEN** the corresponding `NotificationPayload` is emitted on the facade's message stream
  and a tap can be simulated
