import 'package:flutter_test/flutter_test.dart';
import 'package:vm_notifications/vm_notifications.dart';

void main() {
  const payload = NotificationPayload(
    title: 'Title',
    body: 'Body',
    kind: NotificationKind.push,
  );

  group('FakeNotificationProvider', () {
    test('token defaults to null with no initial token', () async {
      final provider = FakeNotificationProvider();

      expect(await provider.token, isNull);
    });

    test('setToken updates token and emits on tokenChanges', () async {
      final provider = FakeNotificationProvider();
      final emitted = <String>[];
      final subscription = provider.tokenChanges.listen(emitted.add);
      addTearDown(subscription.cancel);

      provider.setToken('new-token');
      await Future<void>.delayed(Duration.zero);

      expect(await provider.token, 'new-token');
      expect(emitted, ['new-token']);
    });

    test('registerChannels records the given channels', () async {
      final provider = FakeNotificationProvider();
      const channel = NotificationChannel(id: 'default', name: 'Default');

      await provider.registerChannels(const [channel]);

      expect(provider.channels, [channel]);
    });

    test('simulateIncomingPush emits the payload on messages', () async {
      final provider = FakeNotificationProvider();
      final emitted = <NotificationPayload>[];
      final subscription = provider.messages.listen(emitted.add);
      addTearDown(subscription.cancel);

      provider.simulateIncomingPush(payload);
      await Future<void>.delayed(Duration.zero);

      expect(emitted, [payload]);
    });

    test('simulateTap emits the payload on taps', () async {
      final provider = FakeNotificationProvider();
      final emitted = <NotificationPayload>[];
      final subscription = provider.taps.listen(emitted.add);
      addTearDown(subscription.cancel);

      provider.simulateTap(payload);
      await Future<void>.delayed(Duration.zero);

      expect(emitted, [payload]);
    });
  });
}
