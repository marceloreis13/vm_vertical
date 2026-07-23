## 1. Scaffold module

- [x] 1.1 Create `packages/vm_notifications` with the standard scaffold (barrel
  `lib/vm_notifications.dart`, private `lib/src/`, `resolution: workspace`) and add it to the
  root `workspace:` list in `pubspec.yaml`.
- [x] 1.2 Add deps (`get_it`, `injectable`, `freezed_annotation`, `json_annotation`) and dev
  deps (`build_runner`, `freezed`, `json_serializable`, `injectable_generator`, `mocktail`);
  wire `build.yaml` if needed.
- [x] 1.3 Confirm the shared lint (including `implementation_imports`) applies to the package.

## 2. Domain contracts

- [x] 2.1 Define the `NotificationPayload` value object (Freezed): `title`, `body`, typed
  `data` map, delivery kind (push/local).
- [x] 2.2 Define the sealed `NotificationFailure` and the `Result` usage for fallible ops.
- [x] 2.3 Define the `PushProvider` port (token, `tokenChanges`, message stream, tap events).
- [x] 2.4 Define the `LocalScheduler` port (`schedule`, `cancel`, `cancelAll`, channels).
- [x] 2.5 Define the `NotificationRouter` typedef and the optional `enabled` predicate
  contract.

## 3. Facade + orchestration

- [x] 3.1 Implement `NotificationService` over the two ports: token access, unified
  foreground/background message stream, and local scheduling.
- [x] 3.2 Enforce the `enabled` gate (default always-on) before scheduling and tap handling.
- [x] 3.3 Invoke the injected `NotificationRouter` on tap; catch and isolate handler errors
  (debug-seam log) so handling never crashes.
- [x] 3.4 Map provider exceptions to `NotificationFailure` via `Result`; keep the message
  stream alive after a provider error.

## 4. Fake provider

- [x] 4.1 Implement `FakeNotificationProvider` implementing both ports in memory: record
  scheduled locals, reflect cancellations.
- [x] 4.2 Add hooks to simulate an incoming push and a tap that drive the facade streams.

## 5. Configuration + DI

- [x] 5.1 Define `VmNotificationsConfig` (provider, `NotificationRouter`, optional `enabled`,
  default channel settings) with safe defaults for optional fields.
- [x] 5.2 Implement the single registration function (GetIt + Injectable) that takes the
  config and binds the facade and ports.

## 6. Tests

- [x] 6.1 Unit tests: local scheduling/cancel/cancelAll against the fake (vm-testing).
- [x] 6.2 Unit tests: tap→route invokes the `NotificationRouter` with the tapped payload;
  faulty handler is isolated.
- [x] 6.3 Unit tests: `enabled` gate short-circuits scheduling and handling.
- [x] 6.4 Unit tests: provider exception maps to `NotificationFailure` and the message
  stream survives an error.

## 7. Example app

- [x] 7.1 Build the standalone `example/` (vm_storyboard) that schedules a local and
  simulates a push via the fake, and routes to a target screen on tap through an injected
  `NotificationRouter`.
- [x] 7.2 Promote any missing generic UI component to `vm_storyboard`.

## 8. Docs + verification

- [x] 8.1 Register `vm_notifications` in `docs/` (index + module page) per project rule.
- [x] 8.2 Run `dart format`, `dart analyze`, and `flutter test` across the package; ensure
  green.
