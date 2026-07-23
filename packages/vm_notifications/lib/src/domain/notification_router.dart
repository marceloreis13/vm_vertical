import 'notification_payload.dart';

/// App-injected tap→route seam. The facade invokes this with the tapped
/// [NotificationPayload]; the app maps it to a destination and navigates.
/// `vm_notifications` never depends on `vm_navigation` and never references
/// the app's routes — this callback is the only bridge.
typedef NotificationRouter = Future<void> Function(NotificationPayload payload);

/// App-injected on/off gate, checked before scheduling or handling a tap.
/// Defaults to always-on when the app supplies none. The app may wire it to
/// a `vm_config` flag; `vm_notifications` never depends on `vm_config`.
typedef NotificationEnabledGate = bool Function();
