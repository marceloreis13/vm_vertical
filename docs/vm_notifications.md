# `vm_notifications`

Provider-agnostic push and local notifications module for the vm_core
platform. `NotificationService` is the single API consumers depend on for
both push (token access, foreground/background message stream, taps) and
local scheduling (`schedule`/`cancel`/`cancelAll`, channels). No vendor SDK
type (Firebase Messaging, APNs, `flutter_local_notifications`) appears in the
public API — the concrete provider is a single injected `NotificationProvider`
implementing both the `PushProvider` and `LocalScheduler` ports.

Tap→route and the on/off gate are **injected seams, not hard dependencies**:

- `NotificationRouter` (`NotificationPayload → Future<void>`) — the app wires
  it to its navigator service. `vm_notifications` has **no dependency on
  `vm_navigation`** and never references the app's routes. A faulty handler
  is caught and isolated so notification handling never crashes.
- `enabled` predicate (`bool Function()`, optional, defaults to always-on) —
  the app may wire it to a `vm_config` flag. `vm_notifications` has **no
  dependency on `vm_config`**.

Provider operations that can fail (`schedule`, `cancel`, `cancelAll`) return a
`Result<T, NotificationFailure>`; the facade catches provider exceptions and
maps them to a typed failure rather than throwing into the call site. The
message stream stays usable after a provider error (isolated + logged via a
`dart:developer` debug seam).

Notification **permissions are out of scope**: the module assumes permission
is granted and leaves room on the `PushProvider` port for a future
`vm_permissions` integration or a concrete provider to add it.

## Register at app startup

```dart
registerVmNotificationsModule(
  getIt,
  config: VmNotificationsConfig(
    provider: myFirebaseNotificationProvider, // or FakeNotificationProvider()
    router: (payload) async {
      await getIt<VmNavigatorService>().pushNamed(routeFor(payload));
    },
    enabled: () => getIt<ConfigReader>().getBool('notifications_enabled', true),
    defaultChannels: const [
      NotificationChannel(id: 'default', name: 'Default'),
    ],
  ),
);
```

`provider` and `router` are **required**; `enabled` and `defaultChannels` are
optional — omitting `enabled` defaults to always-on.

## Use the facade

```dart
final service = getIt<NotificationService>();

final token = await service.token; // never throws; null when unavailable
service.tokenChanges.listen((token) => ...);
service.messages.listen((payload) => ...); // push + local, foreground/background

final result = await service.schedule(
  payload: const NotificationPayload(title: 'Reminder', body: 'Do the thing', kind: NotificationKind.local),
  scheduledAt: DateTime.now().add(const Duration(hours: 1)),
  channelId: 'default',
);
result.when(
  success: (id) => print('scheduled $id'),
  failure: (failure) => print('failed: $failure'),
);

await service.cancel(id);
await service.cancelAll();
```

## Built-in fake provider

`FakeNotificationProvider` implements both ports in memory: `scheduled`/
`channels` expose what was recorded, and `simulateIncomingPush`/`simulateTap`
drive the facade's streams — no native plugin required. Used by the module's
own tests and by `example/`.

## Visual example

`packages/vm_notifications/example/` is a standalone Flutter app (no `apps/`
dependency) that registers the module with `FakeNotificationProvider` and a
router pushing a target screen. The demo (`NotificationDemoScreen`,
`NotificationDemoCubit`) lives in `lib/` and is exported by the barrel, so any
app can embed it directly via `package:vm_notifications/vm_notifications.dart`
— `example/` is only a thin shell that registers the module and runs it.
Buttons schedule a local notification, simulate an incoming push, and tap the
last received notification to exercise the injected `NotificationRouter`.
