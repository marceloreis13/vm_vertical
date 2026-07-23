import 'package:flutter_test/flutter_test.dart';
import 'package:vm_analytics/vm_analytics.dart';

void main() {
  group('DebugAnalyticsProvider', () {
    late DebugAnalyticsProvider provider;

    setUp(() {
      provider = DebugAnalyticsProvider();
    });

    tearDown(() => provider.dispose());

    test('buffers received calls, oldest first', () async {
      await provider.logEvent(AnalyticsEvent(name: 'app_opened'));
      await provider.screenView('home');

      expect(provider.buffer, hasLength(2));
      expect(provider.buffer.first, isA<LogEventCall>());
      expect(provider.buffer.last, isA<ScreenViewCall>());
    });

    test('emits each call on the observable stream in order', () async {
      final emitted = <AnalyticsCall>[];
      final subscription = provider.calls.listen(emitted.add);

      await provider.setUserProperty('plan', 'pro');
      await provider.setUserId('42');
      await provider.reset();
      await Future<void>.delayed(Duration.zero);

      expect(emitted, hasLength(3));
      expect(emitted[0], isA<SetUserPropertyCall>());
      expect(emitted[1], isA<SetUserIdCall>());
      expect(emitted[2], isA<ResetCall>());

      await subscription.cancel();
    });
  });
}
