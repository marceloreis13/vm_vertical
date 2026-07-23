import 'dart:developer' as developer;

/// Internal seam for reporting an isolated `vm_notifications` failure (a
/// provider exception, a message-stream error, or a faulty
/// `NotificationRouter`). Kept behind an interface (rather than a bare
/// `dart:developer` call inline) so the eventual swap onto `vm_logging` is a
/// re-home, mirroring `vm_config`/`vm_analytics`/`vm_network`'s own debug
/// seams.
abstract interface class NotificationDebugLog {
  void reportProviderError(
    Object error,
    StackTrace stackTrace, {
    required String operation,
  });

  void reportRouterError(Object error, StackTrace stackTrace);
}

/// Default [NotificationDebugLog] implementation, writing via
/// `dart:developer`.
class DeveloperNotificationDebugLog implements NotificationDebugLog {
  const DeveloperNotificationDebugLog();

  @override
  void reportProviderError(
    Object error,
    StackTrace stackTrace, {
    required String operation,
  }) {
    developer.log(
      'vm_notifications: $operation failed: $error',
      name: 'vm_notifications',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void reportRouterError(Object error, StackTrace stackTrace) {
    developer.log(
      'vm_notifications: NotificationRouter threw: $error',
      name: 'vm_notifications',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
