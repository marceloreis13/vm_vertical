import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/notification_payload.dart';

part 'notification_demo_state.freezed.dart';

/// State of the `vm_notifications` visual example: the current push token,
/// the log of received/simulated notifications, the ids scheduled so far,
/// and the last failure message (if any).
@freezed
class NotificationDemoState with _$NotificationDemoState {
  const factory NotificationDemoState({
    String? token,
    @Default(<NotificationPayload>[]) List<NotificationPayload> receivedLog,
    @Default(<String>[]) List<String> scheduledIds,
    String? lastFailure,
  }) = _NotificationDemoState;

  factory NotificationDemoState.initial() => const NotificationDemoState();
}
