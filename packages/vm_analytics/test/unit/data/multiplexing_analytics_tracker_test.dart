import 'package:flutter_test/flutter_test.dart';
import 'package:vm_analytics/src/data/tracker/multiplexing_analytics_tracker.dart';
import 'package:vm_analytics/vm_analytics.dart';

import '../../fakes/fake_analytics_debug_log.dart';
import '../../fakes/fake_analytics_provider.dart';

void main() {
  group('MultiplexingAnalyticsTracker', () {
    test('delivers an event to all registered providers', () async {
      final providers = List.generate(3, (_) => FakeAnalyticsProvider());
      final tracker = MultiplexingAnalyticsTracker(
        providers: providers,
        debugLog: FakeAnalyticsDebugLog(),
      );
      final event = AnalyticsEvent(name: 'checkout_started');

      await tracker.logEvent(event);

      for (final provider in providers) {
        expect(provider.received, hasLength(1));
        expect(provider.received.single, isA<LogEventCall>());
      }
    });

    test(
      'one throwing provider does not block delivery to the others',
      () async {
        final throwing = FakeAnalyticsProvider(throwOn: 'logEvent');
        final healthyA = FakeAnalyticsProvider();
        final healthyB = FakeAnalyticsProvider();
        final tracker = MultiplexingAnalyticsTracker(
          providers: [healthyA, throwing, healthyB],
          debugLog: FakeAnalyticsDebugLog(),
        );

        await expectLater(
          tracker.logEvent(AnalyticsEvent(name: 'checkout_started')),
          completes,
        );

        expect(healthyA.received, hasLength(1));
        expect(healthyB.received, hasLength(1));
        expect(throwing.received, isEmpty);
      },
    );

    test('an isolated failure is reported via the debug seam', () async {
      final throwing = FakeAnalyticsProvider(throwOn: 'logEvent');
      final debugLog = FakeAnalyticsDebugLog();
      final tracker = MultiplexingAnalyticsTracker(
        providers: [throwing],
        debugLog: debugLog,
      );

      await tracker.logEvent(AnalyticsEvent(name: 'checkout_started'));

      expect(debugLog.reportedOperations, ['logEvent']);
    });

    test('with zero providers, every call is a safe no-op', () async {
      final tracker = MultiplexingAnalyticsTracker(
        providers: const [],
        debugLog: FakeAnalyticsDebugLog(),
      );

      await expectLater(
        tracker.logEvent(AnalyticsEvent(name: 'checkout_started')),
        completes,
      );
      await expectLater(tracker.setUserProperty('plan', 'pro'), completes);
      await expectLater(tracker.screenView('home'), completes);
      await expectLater(tracker.setUserId('42'), completes);
      await expectLater(tracker.reset(), completes);
    });

    test('setUserProperty fans out to every provider', () async {
      final providers = List.generate(2, (_) => FakeAnalyticsProvider());
      final tracker = MultiplexingAnalyticsTracker(
        providers: providers,
        debugLog: FakeAnalyticsDebugLog(),
      );

      await tracker.setUserProperty('plan', 'pro');

      for (final provider in providers) {
        expect(
          provider.received.single,
          isA<SetUserPropertyCall>()
              .having((c) => c.name, 'name', 'plan')
              .having((c) => c.value, 'value', 'pro'),
        );
      }
    });

    test('reset instructs every provider to clear identity', () async {
      final providers = List.generate(2, (_) => FakeAnalyticsProvider());
      final tracker = MultiplexingAnalyticsTracker(
        providers: providers,
        debugLog: FakeAnalyticsDebugLog(),
      );

      await tracker.reset();

      for (final provider in providers) {
        expect(provider.received.single, isA<ResetCall>());
      }
    });

    test(
      'screenView validates the name before reaching any provider',
      () async {
        final provider = FakeAnalyticsProvider();
        final tracker = MultiplexingAnalyticsTracker(
          providers: [provider],
          debugLog: FakeAnalyticsDebugLog(),
        );

        expect(() => tracker.screenView('Invalid Name'), throwsArgumentError);
        expect(provider.received, isEmpty);
      },
    );

    test('screenView fans out a valid name to every provider', () async {
      final providers = List.generate(2, (_) => FakeAnalyticsProvider());
      final tracker = MultiplexingAnalyticsTracker(
        providers: providers,
        debugLog: FakeAnalyticsDebugLog(),
      );

      await tracker.screenView('home');

      for (final provider in providers) {
        expect(
          provider.received.single,
          isA<ScreenViewCall>().having((c) => c.name, 'name', 'home'),
        );
      }
    });
  });
}
