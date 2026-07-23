import 'package:vm_analytics/vm_analytics.dart';

/// A hand-written fake [AnalyticsProvider] that records every call it
/// receives, optionally throwing on a chosen operation to exercise
/// per-provider error isolation.
class FakeAnalyticsProvider implements AnalyticsProvider {
  FakeAnalyticsProvider({this.throwOn});

  /// When set, the matching operation throws instead of recording.
  final String? throwOn;

  final List<AnalyticsCall> received = [];

  @override
  Future<void> logEvent(AnalyticsEvent event) =>
      _handle('logEvent', () => received.add(AnalyticsCall.logEvent(event)));

  @override
  Future<void> setUserProperty(String name, Object? value) => _handle(
    'setUserProperty',
    () => received.add(AnalyticsCall.setUserProperty(name: name, value: value)),
  );

  @override
  Future<void> screenView(String name) =>
      _handle('screenView', () => received.add(AnalyticsCall.screenView(name)));

  @override
  Future<void> setUserId(String? id) =>
      _handle('setUserId', () => received.add(AnalyticsCall.setUserId(id)));

  @override
  Future<void> reset() =>
      _handle('reset', () => received.add(const AnalyticsCall.reset()));

  Future<void> _handle(String operation, void Function() record) async {
    if (throwOn == operation) {
      throw StateError('$operation failed');
    }
    record();
  }
}
