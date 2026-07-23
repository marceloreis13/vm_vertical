import '../../domain/analytics_event.dart';
import '../../domain/analytics_provider.dart';

/// Built-in [AnalyticsProvider] that accepts every call and does nothing.
/// For standalone runs and tests where no observable output is needed.
class NoopAnalyticsProvider implements AnalyticsProvider {
  const NoopAnalyticsProvider();

  @override
  Future<void> logEvent(AnalyticsEvent event) async {}

  @override
  Future<void> setUserProperty(String name, Object? value) async {}

  @override
  Future<void> screenView(String name) async {}

  @override
  Future<void> setUserId(String? id) async {}

  @override
  Future<void> reset() async {}
}
