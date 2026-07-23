import 'package:vm_analytics/src/data/debug/analytics_debug_log.dart';
import 'package:vm_analytics/vm_analytics.dart';

/// A hand-written fake [AnalyticsDebugLog] that records isolated provider
/// failures instead of writing to `dart:developer`.
class FakeAnalyticsDebugLog implements AnalyticsDebugLog {
  final List<String> reportedOperations = [];

  @override
  void reportProviderFailure(
    AnalyticsProvider provider,
    Object error,
    StackTrace stackTrace, {
    required String operation,
  }) {
    reportedOperations.add(operation);
  }
}
