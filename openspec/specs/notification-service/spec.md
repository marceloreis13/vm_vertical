## Purpose

Define the unified, vendor-agnostic `NotificationService` facade: push token access, the foreground/background message stream, local scheduling, and the `NotificationPayload` value object.

## Requirements

### Requirement: Unified notification facade

The module SHALL expose an injectable (GetIt-registered) `NotificationService` facade that
is the single API consumers depend on for both push and local notifications, and no vendor
SDK type SHALL appear in its public API.

#### Scenario: Consumers depend only on the facade

- **WHEN** a module or app resolves `NotificationService` via GetIt to access push tokens,
  the message stream, or local scheduling
- **THEN** it interacts only with vendor-free types (facade, `NotificationPayload`,
  `NotificationFailure`) and no Firebase/APNs/`flutter_local_notifications` type is reachable
  through the public API

### Requirement: Push token access

The facade SHALL expose the current push token and a stream of token changes.

#### Scenario: Reading the current token

- **WHEN** a consumer reads `token`
- **THEN** the facade returns the provider's current push token (or `null` when none is
  available) without throwing

#### Scenario: Observing token refresh

- **WHEN** the underlying provider rotates the push token
- **THEN** the new token is emitted on `tokenChanges`

### Requirement: Foreground and background message stream

The facade SHALL expose a single `Stream<NotificationPayload>` that emits notifications
received in both foreground and background, each payload carrying its delivery kind.

#### Scenario: Foreground push emitted

- **WHEN** the provider receives a push while the app is in the foreground
- **THEN** a `NotificationPayload` with the push kind is emitted on the message stream

#### Scenario: Background push emitted

- **WHEN** the provider receives a push while the app is in the background
- **THEN** a `NotificationPayload` with the push kind is emitted on the message stream

### Requirement: Local notification scheduling

The facade SHALL let consumers schedule a local notification for a given time, and cancel a
single scheduled notification by id or cancel all scheduled notifications.

#### Scenario: Schedule a local notification

- **WHEN** a consumer calls `schedule` with a title, body, target time, channel, and typed
  data
- **THEN** the notification is registered with the provider and the call returns a
  `Result` success carrying its scheduled id

#### Scenario: Cancel a scheduled notification

- **WHEN** a consumer calls `cancel` with the id of a previously scheduled notification
- **THEN** that notification is removed from the provider's scheduled set and no others are
  affected

#### Scenario: Cancel all scheduled notifications

- **WHEN** a consumer calls `cancelAll`
- **THEN** every scheduled local notification is removed from the provider

### Requirement: NotificationPayload value object

The module SHALL define a provider-agnostic `NotificationPayload` value object carrying the
`title`, `body`, a typed `data` map, and the delivery kind (push or local); it is the unit
emitted on the message stream and passed to the tap handler.

#### Scenario: Payload exposes typed data

- **WHEN** a notification is received or a scheduled local fires
- **THEN** the corresponding `NotificationPayload` exposes its title, body, delivery kind,
  and the typed `data` map used for routing, with no vendor type
