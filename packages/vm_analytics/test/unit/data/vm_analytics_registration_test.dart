import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_analytics/vm_analytics.dart';

import '../../fakes/fake_analytics_provider.dart';

void main() {
  late GetIt getIt;

  setUp(() {
    getIt = GetIt.asNewInstance();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('registerVmAnalyticsModule', () {
    test(
      'resolves the AnalyticsTracker abstraction, not a concrete provider',
      () {
        registerVmAnalyticsModule(getIt, config: const VmAnalyticsConfig());

        expect(getIt<AnalyticsTracker>(), isA<AnalyticsTracker>());
      },
    );

    test('also resolves the AnalyticsRouteObserver', () {
      registerVmAnalyticsModule(getIt, config: const VmAnalyticsConfig());

      expect(getIt<AnalyticsRouteObserver>(), isA<AnalyticsRouteObserver>());
    });

    test(
      'config providers receive calls made through the resolved tracker',
      () async {
        final provider = FakeAnalyticsProvider();
        registerVmAnalyticsModule(
          getIt,
          config: VmAnalyticsConfig(providers: [provider]),
        );

        await getIt<AnalyticsTracker>().logEvent(
          AnalyticsEvent(name: 'app_opened'),
        );

        expect(provider.received, hasLength(1));
      },
    );

    test('with zero providers configured, tracking is a safe no-op', () async {
      registerVmAnalyticsModule(getIt, config: const VmAnalyticsConfig());

      await expectLater(
        getIt<AnalyticsTracker>().logEvent(AnalyticsEvent(name: 'app_opened')),
        completes,
      );
    });
  });
}
