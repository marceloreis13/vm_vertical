import 'package:flutter_test/flutter_test.dart';
import 'package:vm_analytics/vm_analytics.dart';

void main() {
  group('NoopAnalyticsProvider', () {
    const provider = NoopAnalyticsProvider();

    test('every call completes successfully without side effects', () async {
      await expectLater(
        provider.logEvent(AnalyticsEvent(name: 'app_opened')),
        completes,
      );
      await expectLater(provider.setUserProperty('plan', 'pro'), completes);
      await expectLater(provider.screenView('home'), completes);
      await expectLater(provider.setUserId('42'), completes);
      await expectLater(provider.reset(), completes);
    });
  });
}
