/// The delivery kind of a [NotificationPayload]: whether it arrived as a
/// push notification from the injected `PushProvider`, or was scheduled and
/// fired as a local notification through the injected `LocalScheduler`.
enum NotificationKind { push, local }
