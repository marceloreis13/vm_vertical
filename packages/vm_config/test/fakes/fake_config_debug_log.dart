import 'package:vm_config/src/core/config_failure.dart';
import 'package:vm_config/src/data/debug/config_debug_log.dart';

/// A hand-written fake [ConfigDebugLog] that records isolated failures
/// instead of writing to `dart:developer`.
class FakeConfigDebugLog implements ConfigDebugLog {
  final List<ConfigFailure> reportedFetchFailures = [];
  final List<String> reportedCacheOperations = [];
  final List<String> reportedTypeMismatchKeys = [];

  @override
  void reportFetchFailure(ConfigFailure failure, {StackTrace? stackTrace}) {
    reportedFetchFailures.add(failure);
  }

  @override
  void reportCacheFailure(
    Object error,
    StackTrace stackTrace, {
    required String operation,
  }) {
    reportedCacheOperations.add(operation);
  }

  @override
  void reportTypeMismatch({
    required String key,
    required Type expected,
    required Type actual,
  }) {
    reportedTypeMismatchKeys.add(key);
  }
}
