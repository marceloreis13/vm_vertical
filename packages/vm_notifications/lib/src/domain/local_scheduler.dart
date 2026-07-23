import 'notification_channel.dart';
import 'notification_payload.dart';

/// Port covering local notifications: channel/category setup, scheduling
/// and cancellation. A concrete implementation (`flutter_local_notifications`
/// or similar) is supplied by the consuming app; the facade and every call
/// site depend on this abstraction only.
abstract interface class LocalScheduler {
  /// Registers the app's default channels/categories. Called once at
  /// registration with `VmNotificationsConfig.defaultChannels`.
  Future<void> registerChannels(List<NotificationChannel> channels);

  /// Schedules [payload] to fire at [scheduledAt] on [channelId] (or the
  /// provider's default channel when omitted). Returns the id the
  /// notification was scheduled under, used by [cancel].
  Future<String> schedule({
    required NotificationPayload payload,
    required DateTime scheduledAt,
    String? channelId,
  });

  /// Cancels the single scheduled notification identified by [id]. No
  /// other scheduled notification is affected.
  Future<void> cancel(String id);

  /// Cancels every scheduled notification.
  Future<void> cancelAll();
}
