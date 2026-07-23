import 'package:flutter_test/flutter_test.dart';
import 'package:vm_notifications/src/data/notification_service_impl.dart';
import 'package:vm_notifications/vm_notifications.dart';

void main() {
  late FakeNotificationProvider provider;

  setUp(() {
    provider = FakeNotificationProvider();
  });

  const payload = NotificationPayload(
    title: 'Push title',
    body: 'Push body',
    kind: NotificationKind.push,
  );

  group('tap-to-route', () {
    test(
      'invokes the injected NotificationRouter with the tapped payload',
      () async {
        NotificationPayload? routed;
        final service = NotificationServiceImpl(
          pushProvider: provider,
          localScheduler: provider,
          router: (payload) async {
            routed = payload;
          },
        );
        // Attach a listener so the facade starts forwarding push/tap streams.
        final subscription = service.messages.listen((_) {});
        addTearDown(subscription.cancel);
        await Future<void>.delayed(Duration.zero);

        provider.simulateTap(payload);
        await Future<void>.delayed(Duration.zero);

        expect(routed, payload);
      },
    );

    test(
      'a faulty NotificationRouter is isolated and does not crash handling',
      () async {
        var routerCalls = 0;
        final service = NotificationServiceImpl(
          pushProvider: provider,
          localScheduler: provider,
          router: (payload) async {
            routerCalls++;
            throw StateError('faulty handler');
          },
        );
        final subscription = service.messages.listen((_) {});
        addTearDown(subscription.cancel);
        await Future<void>.delayed(Duration.zero);

        provider.simulateTap(payload);
        await Future<void>.delayed(Duration.zero);
        // A second tap proves handling continues after the faulty handler threw.
        provider.simulateTap(payload);
        await Future<void>.delayed(Duration.zero);

        expect(routerCalls, 2);
      },
    );
  });

  group('enabled gate', () {
    test('gate defaults to enabled when no predicate is injected', () async {
      final service = NotificationServiceImpl(
        pushProvider: provider,
        localScheduler: provider,
        router: (_) async {},
      );

      final result = await service.schedule(
        payload: payload,
        scheduledAt: DateTime(2030),
      );

      expect(result.isSuccess, isTrue);
    });

    test('gate short-circuits scheduling when disabled', () async {
      final service = NotificationServiceImpl(
        pushProvider: provider,
        localScheduler: provider,
        router: (_) async {},
        enabled: () => false,
      );

      final result = await service.schedule(
        payload: payload,
        scheduledAt: DateTime(2030),
      );

      expect(result.isFailure, isTrue);
      expect(provider.scheduled, isEmpty);
    });

    test('gate short-circuits tap handling when disabled', () async {
      var routerCalls = 0;
      final service = NotificationServiceImpl(
        pushProvider: provider,
        localScheduler: provider,
        router: (_) async {
          routerCalls++;
        },
        enabled: () => false,
      );
      final subscription = service.messages.listen((_) {});
      addTearDown(subscription.cancel);
      await Future<void>.delayed(Duration.zero);

      provider.simulateTap(payload);
      await Future<void>.delayed(Duration.zero);

      expect(routerCalls, 0);
    });
  });
}
