import '../core/notification_failure.dart';
import '../core/result.dart';
import '../core/unit.dart';
import 'notification_payload.dart';

/// The single API consumers depend on for both push and local
/// notifications. No vendor SDK type appears here: consumers interact only
/// with this facade, [NotificationPayload] and [NotificationFailure].
abstract interface class NotificationService {
  /// The current push token, or `null` when none is available. Never
  /// throws.
  Future<String?> get token;

  /// Emits a new token whenever the provider rotates it.
  Stream<String> get tokenChanges;

  /// Emits every notification received in foreground or background (push)
  /// and every local notification fired, each carrying its delivery kind.
  /// Stays usable after a provider error: errors are isolated and logged.
  Stream<NotificationPayload> get messages;

  /// Schedules a local notification for [scheduledAt]. Short-circuits with
  /// `false` gate to a no-op success when the injected `enabled` gate
  /// returns `false`. Returns the scheduled id on success, or a
  /// [ScheduleFailure] if the underlying provider throws.
  Future<Result<String, NotificationFailure>> schedule({
    required NotificationPayload payload,
    required DateTime scheduledAt,
    String? channelId,
  });

  /// Cancels the scheduled notification identified by [id].
  Future<Result<Unit, NotificationFailure>> cancel(String id);

  /// Cancels every scheduled local notification.
  Future<Result<Unit, NotificationFailure>> cancelAll();
}
