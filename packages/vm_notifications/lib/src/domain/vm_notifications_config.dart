import 'notification_channel.dart';
import 'notification_provider.dart';
import 'notification_router.dart';

/// Configuration for the `vm_notifications` module, always supplied by the
/// consuming app via `registerVmNotificationsModule`. No vendor key, route
/// or flag is ever hard-coded inside the module — everything it needs
/// arrives through this value.
class VmNotificationsConfig {
  const VmNotificationsConfig({
    required this.provider,
    required this.router,
    this.enabled,
    this.defaultChannels = const [],
  });

  /// The concrete provider, translated to the module's two ports. Consuming
  /// apps implement [NotificationProvider] over concrete vendor SDKs, or use
  /// the built-in `FakeNotificationProvider`.
  final NotificationProvider provider;

  /// Tap→route seam the app wires to its navigator service.
  final NotificationRouter router;

  /// Optional on/off gate; defaults to always-on when omitted.
  final NotificationEnabledGate? enabled;

  /// Default local-notification channels/categories registered at startup.
  final List<NotificationChannel> defaultChannels;
}
