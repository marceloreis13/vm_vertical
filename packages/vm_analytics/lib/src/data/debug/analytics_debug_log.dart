import 'dart:developer' as developer;

import '../../domain/analytics_provider.dart';

/// Internal seam for reporting an isolated provider failure. Kept behind an
/// interface (rather than a bare `dart:developer` call inline) so the
/// eventual swap onto `vm_logging` is a re-home, mirroring `vm_network` and
/// `vm_logging`'s own `console_fallback.dart`.
abstract interface class AnalyticsDebugLog {
  void reportProviderFailure(
    AnalyticsProvider provider,
    Object error,
    StackTrace stackTrace, {
    required String operation,
  });
}

/// Default [AnalyticsDebugLog] implementation, writing via `dart:developer`.
class DeveloperAnalyticsDebugLog implements AnalyticsDebugLog {
  const DeveloperAnalyticsDebugLog();

  @override
  void reportProviderFailure(
    AnalyticsProvider provider,
    Object error,
    StackTrace stackTrace, {
    required String operation,
  }) {
    developer.log(
      'vm_analytics: provider $provider threw during $operation: $error',
      name: 'vm_analytics',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
