import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_channel.freezed.dart';

/// A local-notification channel/category (Android channel, iOS category):
/// an app-defined grouping a scheduled local notification targets. The app
/// supplies its default set via `VmNotificationsConfig.defaultChannels`; the
/// module holds no channel of its own.
@freezed
class NotificationChannel with _$NotificationChannel {
  const factory NotificationChannel({
    required String id,
    required String name,
    String? description,
  }) = _NotificationChannel;
}
