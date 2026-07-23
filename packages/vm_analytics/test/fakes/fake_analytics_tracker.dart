import 'package:vm_analytics/vm_analytics.dart';

/// A hand-written fake [AnalyticsTracker] that records every call it
/// receives, for asserting what `AnalyticsRouteObserver` (or any other
/// caller) dispatched.
class FakeAnalyticsTracker implements AnalyticsTracker {
  final List<AnalyticsCall> received = [];

  @override
  Future<void> logEvent(AnalyticsEvent event) async =>
      received.add(AnalyticsCall.logEvent(event));

  @override
  Future<void> setUserProperty(String name, Object? value) async =>
      received.add(AnalyticsCall.setUserProperty(name: name, value: value));

  @override
  Future<void> screenView(String name) async =>
      received.add(AnalyticsCall.screenView(name));

  @override
  Future<void> setUserId(String? id) async =>
      received.add(AnalyticsCall.setUserId(id));

  @override
  Future<void> reset() async => received.add(const AnalyticsCall.reset());
}
