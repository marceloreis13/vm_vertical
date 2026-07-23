import 'local_scheduler.dart';
import 'push_provider.dart';

/// The concrete provider the app injects via `VmNotificationsConfig`: one
/// object implementing both the [PushProvider] and [LocalScheduler] ports.
/// A single implementation combining both keeps the two native concerns
/// independently testable/fakeable while giving the app one thing to wire
/// (see the module's built-in `FakeNotificationProvider`).
abstract interface class NotificationProvider
    implements PushProvider, LocalScheduler {}
