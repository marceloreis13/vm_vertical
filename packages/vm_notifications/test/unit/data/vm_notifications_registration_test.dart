import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_notifications/vm_notifications.dart';

void main() {
  late GetIt getIt;

  setUp(() {
    getIt = GetIt.asNewInstance();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('registerVmNotificationsModule', () {
    test('resolves the NotificationService abstraction', () {
      final provider = FakeNotificationProvider();

      registerVmNotificationsModule(
        getIt,
        config: VmNotificationsConfig(provider: provider, router: (_) async {}),
      );

      expect(getIt<NotificationService>(), isA<NotificationService>());
    });

    test('registers the default channels with the provider', () async {
      final provider = FakeNotificationProvider();
      const channel = NotificationChannel(id: 'default', name: 'Default');

      registerVmNotificationsModule(
        getIt,
        config: VmNotificationsConfig(
          provider: provider,
          router: (_) async {},
          defaultChannels: const [channel],
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(provider.channels, [channel]);
    });

    test('registers and runs without an enabled gate wired', () async {
      final provider = FakeNotificationProvider();

      registerVmNotificationsModule(
        getIt,
        config: VmNotificationsConfig(provider: provider, router: (_) async {}),
      );

      final result = await getIt<NotificationService>().schedule(
        payload: const NotificationPayload(
          title: 't',
          body: 'b',
          kind: NotificationKind.local,
        ),
        scheduledAt: DateTime(2030),
      );

      expect(result.isSuccess, isTrue);
    });
  });
}
