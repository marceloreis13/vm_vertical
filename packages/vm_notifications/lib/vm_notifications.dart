/// vm_notifications: a provider-agnostic push and local notifications
/// module. Consumers depend on the `NotificationService` facade only — the
/// consuming app decides the concrete provider, the tap→route handler and
/// the optional enable gate via `registerVmNotificationsModule`. No vendor
/// SDK type, and no `vm_navigation`/`vm_config` dependency, appears in the
/// public API.
library;

export 'src/core/notification_failure.dart';
export 'src/core/result.dart';
export 'src/core/unit.dart';
export 'src/data/di/vm_notifications_registration.dart';
export 'src/data/fake/fake_notification_provider.dart';
export 'src/domain/local_scheduler.dart';
export 'src/domain/notification_channel.dart';
export 'src/domain/notification_kind.dart';
export 'src/domain/notification_payload.dart';
export 'src/domain/notification_provider.dart';
export 'src/domain/notification_router.dart';
export 'src/domain/notification_service.dart';
export 'src/domain/push_provider.dart';
export 'src/domain/vm_notifications_config.dart';
export 'src/presentation/demo/screen/notification_demo_screen.dart';
