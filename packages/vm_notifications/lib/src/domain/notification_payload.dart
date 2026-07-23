import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification_kind.dart';

part 'notification_payload.freezed.dart';

/// Provider-agnostic value object carrying everything about one
/// notification: its display content, a typed data map used for routing,
/// and its delivery kind. It is the unit emitted on
/// `NotificationService.messages`, passed to a tapped-notification's
/// `NotificationRouter`, and returned by `LocalScheduler`/`PushProvider`
/// implementations. No vendor type appears here.
@freezed
class NotificationPayload with _$NotificationPayload {
  const factory NotificationPayload({
    required String title,
    required String body,
    required NotificationKind kind,
    @Default(<String, Object?>{}) Map<String, Object?> data,
  }) = _NotificationPayload;
}
