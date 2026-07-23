## Why

Apps and modules in the monorepo need to deliver push notifications and schedule local
notifications, but there is no shared notification layer yet. Without one, every consumer
would bind directly to a vendor SDK (Firebase Messaging, `flutter_local_notifications`,
APNs), leaking that SDK into call sites and making a provider swap a cross-cutting
rewrite. Tap-to-navigate would also couple notification handling to the app's concrete
routes. This change delivers `vm_notifications`: a provider-agnostic notification
abstraction where the app injects the concrete provider and the payload→route handler,
and modules schedule locals and react to pushes through one interface without knowing the
vendor or the app's router.

## What Changes

- New `packages/vm_notifications` module following the standard scaffold (barrel,
  `lib/src/`, `example/`, three test kinds, `resolution: workspace`).
- **`NotificationService` facade** — the single API consumers depend on, unifying push and
  local notifications: push token access (`token`, `tokenChanges`), a foreground/background
  message stream, and local scheduling (`schedule`, `cancel`, `cancelAll`) with channels/
  categories. No vendor SDK type appears in the public API.
- **`NotificationPayload` value object** — a provider-agnostic VO carrying the notification
  `title`/`body`, a typed `data` map, and the delivery kind (push vs local). It is the unit
  passed to the tap handler and emitted on the message stream.
- **Pluggable provider over two ports** — a `PushProvider` port (token lifecycle, foreground/
  background reception, tap events) and a `LocalScheduler` port (schedule/cancel, channels).
  The `NotificationService` orchestrates both; a failing provider call is isolated and
  surfaced as a typed `Result`/`NotificationFailure` and never breaks the call site.
- **Built-in `fake` provider** — a single in-memory `FakeNotificationProvider` implementing
  both ports: it records scheduled locals, lets tests/`example` simulate an incoming push,
  and drives the tap→route flow without any native plugin.
- **Injected tap→route seam** — a `NotificationRouter` callback (`NotificationPayload →
  Future<void>`) the app injects and wires to its `vm_navigation` navigator service. The
  module invokes it on tap but has **no dependency on `vm_navigation`** and never references
  the app's routes.
- **Optional enable gate seam** — an injected `enabled` predicate (default always-on) the app
  may wire to a `vm_config` flag. The module reads the gate through the seam and has **no
  dependency on `vm_config`**.
- **Injected configuration** — `VmNotificationsConfig` (the concrete provider, the
  `NotificationRouter`, the optional `enabled` gate, default channel settings) supplied by the
  consuming app through a single DI registration entry point (GetIt + Injectable). No vendor
  key or app-specific value lives in the module.
- **Standalone `example/`** — a visual app (built with `vm_storyboard`) that schedules a local
  notification and simulates an incoming push via the `fake` provider, and on tap routes to a
  target screen through an injected `NotificationRouter`. Any missing generic UI component is
  promoted to `vm_storyboard`.
- Living docs: register `vm_notifications` in `docs/` per project rule.

## Capabilities

### New Capabilities
- `notification-service`: the `NotificationService` facade unifying push (token access,
  foreground/background message stream) and local scheduling (`schedule`, `cancel`,
  `cancelAll`, channels), plus the `NotificationPayload` value object — the vendor-free,
  router-free contract consumers depend on.
- `notification-providers`: the pluggable `PushProvider` and `LocalScheduler` ports, the
  service's orchestration with typed `NotificationFailure` isolation, and the built-in
  in-memory `fake` provider used by tests and the `example`.
- `notification-routing`: the injected `NotificationRouter` tap→route seam (payload →
  navigation, no dependency on `vm_navigation`) and the optional `enabled` gate seam
  (no dependency on `vm_config`).
- `notification-configuration`: the injected `VmNotificationsConfig`, the single DI
  registration entry point, and the standalone visual `example/`.

### Modified Capabilities
<!-- None. This is a new module; no existing spec requirements change. -->

## Impact

- New package `packages/vm_notifications`; added to the root `workspace:` list in
  `pubspec.yaml`.
- **No hard dependency on `vm_navigation` or `vm_config`**: both integrations are injected
  seams the app wires. Concrete vendor providers (Firebase Messaging, APNs,
  `flutter_local_notifications`) and the push-sending backend are **out of scope**; this
  change ships only the `fake` provider.
- Dev deps: `build_runner`, `freezed`, `json_serializable`, `injectable_generator`,
  `mocktail` (fake ports for orchestration/routing unit tests).
- The `example/` depends on `vm_storyboard`; generic UI components missing from the design
  system may be added to `packages/vm_storyboard` as part of this change.
- Notification **permissions** are out of scope for this change: the module assumes
  permission is granted and leaves a seam to delegate to a future `vm_permissions` module.
- `docs/` index updated to include the new module.
- Base (Propose 1) monorepo conventions consumed.
