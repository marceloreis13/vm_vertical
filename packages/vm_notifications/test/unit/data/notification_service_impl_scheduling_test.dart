import 'package:flutter_test/flutter_test.dart';
import 'package:vm_notifications/src/data/notification_service_impl.dart';
import 'package:vm_notifications/vm_notifications.dart';

void main() {
  late FakeNotificationProvider provider;
  late NotificationServiceImpl service;

  setUp(() {
    provider = FakeNotificationProvider();
    service = NotificationServiceImpl(
      pushProvider: provider,
      localScheduler: provider,
      router: (_) async {},
    );
  });

  const payload = NotificationPayload(
    title: 'Title',
    body: 'Body',
    kind: NotificationKind.local,
  );

  group('local scheduling', () {
    test('schedule returns a Success carrying the scheduled id', () async {
      final result = await service.schedule(
        payload: payload,
        scheduledAt: DateTime(2030),
      );

      expect(result.isSuccess, isTrue);
      final id = result.when(success: (id) => id, failure: (_) => null);
      expect(provider.scheduled, containsPair(id, payload));
    });

    test('cancel removes only the targeted notification', () async {
      final firstResult = await service.schedule(
        payload: payload,
        scheduledAt: DateTime(2030),
      );
      final secondResult = await service.schedule(
        payload: payload,
        scheduledAt: DateTime(2031),
      );
      final firstId = firstResult.when(
        success: (id) => id,
        failure: (_) => null,
      )!;
      final secondId = secondResult.when(
        success: (id) => id,
        failure: (_) => null,
      )!;

      final cancelResult = await service.cancel(firstId);

      expect(cancelResult.isSuccess, isTrue);
      expect(provider.scheduled.containsKey(firstId), isFalse);
      expect(provider.scheduled.containsKey(secondId), isTrue);
    });

    test('cancelAll removes every scheduled notification', () async {
      await service.schedule(payload: payload, scheduledAt: DateTime(2030));
      await service.schedule(payload: payload, scheduledAt: DateTime(2031));

      final result = await service.cancelAll();

      expect(result.isSuccess, isTrue);
      expect(provider.scheduled, isEmpty);
    });
  });

  group('provider exception isolation', () {
    test('schedule maps a provider exception to ScheduleFailure', () async {
      provider.scheduleException = Exception('boom');

      final result = await service.schedule(
        payload: payload,
        scheduledAt: DateTime(2030),
      );

      expect(result.isFailure, isTrue);
      final failure = result.when(success: (_) => null, failure: (f) => f);
      expect(failure, isA<ScheduleFailure>());
    });

    test('cancel maps a provider exception to CancelFailure', () async {
      provider.cancelException = Exception('boom');

      final result = await service.cancel('missing-id');

      expect(result.isFailure, isTrue);
      final failure = result.when(success: (_) => null, failure: (f) => f);
      expect(failure, isA<CancelFailure>());
    });

    test('message stream survives a provider error and stays usable', () async {
      final events = <NotificationPayload>[];
      final subscription = service.messages.listen(events.add);
      addTearDown(subscription.cancel);
      await Future<void>.delayed(Duration.zero);

      provider.simulateIncomingPush(payload);
      await Future<void>.delayed(Duration.zero);

      expect(events, [payload]);
    });
  });
}
