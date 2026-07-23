import 'notification_payload.dart';

/// Port covering the push side of notifications: token lifecycle and
/// message/tap reception. A concrete vendor implementation (Firebase
/// Messaging, APNs, ...) is supplied by the consuming app; the facade and
/// every call site depend on this abstraction only.
abstract interface class PushProvider {
  /// The current push token, or `null` when none is available yet. Never
  /// throws; a provider that fails to obtain a token resolves to `null`.
  Future<String?> get token;

  /// Emits a new token whenever the provider rotates it.
  Stream<String> get tokenChanges;

  /// Emits a [NotificationPayload] for every push received in foreground or
  /// background.
  Stream<NotificationPayload> get messages;

  /// Emits the [NotificationPayload] of a push notification the user
  /// tapped.
  Stream<NotificationPayload> get taps;
}
