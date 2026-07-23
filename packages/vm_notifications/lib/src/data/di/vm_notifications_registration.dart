import 'dart:async';

import 'package:get_it/get_it.dart';

import '../../domain/notification_service.dart';
import '../../domain/vm_notifications_config.dart';
import '../notification_service_impl.dart';

/// Single registration entry point for `vm_notifications`. Receives its
/// [config] from the consuming app — no provider, route or flag is
/// hard-coded inside the module. Registers the app's default channels with
/// the provider and the [NotificationService] facade consumers depend on.
void registerVmNotificationsModule(
  GetIt getIt, {
  required VmNotificationsConfig config,
}) {
  getIt.registerSingleton<VmNotificationsConfig>(config);

  unawaited(config.provider.registerChannels(config.defaultChannels));

  getIt.registerSingleton<NotificationService>(
    NotificationServiceImpl(
      pushProvider: config.provider,
      localScheduler: config.provider,
      router: config.router,
      enabled: config.enabled,
    ),
  );
}
