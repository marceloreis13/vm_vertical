// ignore_for_file: prefer_initializing_formals
// (fields are private for encapsulation; the constructor's named parameters
// must stay public, so a plain initializing formal isn't available here.)

import '../../domain/analytics_event.dart';
import '../../domain/analytics_provider.dart';
import '../../domain/analytics_tracker.dart';
import '../../domain/event_name_validator.dart';
import '../debug/analytics_debug_log.dart';

/// The `AnalyticsTracker` implementation: fans out every call to all
/// [_providers], each isolated in its own `try`/`catch` so one throwing
/// provider never blocks delivery to the others and never reaches the call
/// site — failures are reported via [_debugLog] instead. Zero registered
/// providers makes every call a safe no-op. See `analytics-providers`.
class MultiplexingAnalyticsTracker implements AnalyticsTracker {
  MultiplexingAnalyticsTracker({
    required List<AnalyticsProvider> providers,
    required AnalyticsDebugLog debugLog,
  }) : _providers = providers,
       _debugLog = debugLog;

  final List<AnalyticsProvider> _providers;
  final AnalyticsDebugLog _debugLog;

  @override
  Future<void> logEvent(AnalyticsEvent event) =>
      _dispatch('logEvent', (provider) => provider.logEvent(event));

  @override
  Future<void> setUserProperty(String name, Object? value) => _dispatch(
    'setUserProperty',
    (provider) => provider.setUserProperty(name, value),
  );

  @override
  Future<void> screenView(String name) {
    final validName = validateAnalyticsName(name, label: 'screen name');
    return _dispatch(
      'screenView',
      (provider) => provider.screenView(validName),
    );
  }

  @override
  Future<void> setUserId(String? id) =>
      _dispatch('setUserId', (provider) => provider.setUserId(id));

  @override
  Future<void> reset() => _dispatch('reset', (provider) => provider.reset());

  Future<void> _dispatch(
    String operation,
    Future<void> Function(AnalyticsProvider provider) call,
  ) async {
    if (_providers.isEmpty) return;
    await Future.wait(
      _providers.map((provider) async {
        try {
          await call(provider);
        } catch (error, stackTrace) {
          _debugLog.reportProviderFailure(
            provider,
            error,
            stackTrace,
            operation: operation,
          );
        }
      }),
    );
  }
}
