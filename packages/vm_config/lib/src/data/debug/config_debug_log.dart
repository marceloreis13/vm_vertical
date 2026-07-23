import 'dart:developer' as developer;

import '../../core/config_failure.dart';

/// Internal seam for reporting an isolated `vm_config` failure (a remote
/// fetch failure, a cache access failure, or a read-time type mismatch).
/// Kept behind an interface (rather than a bare `dart:developer` call
/// inline) so the eventual swap onto `vm_logging` is a re-home, mirroring
/// `vm_analytics`/`vm_network`'s own debug seams.
abstract interface class ConfigDebugLog {
  void reportFetchFailure(ConfigFailure failure, {StackTrace? stackTrace});

  void reportCacheFailure(
    Object error,
    StackTrace stackTrace, {
    required String operation,
  });

  void reportTypeMismatch({
    required String key,
    required Type expected,
    required Type actual,
  });
}

/// Default [ConfigDebugLog] implementation, writing via `dart:developer`.
class DeveloperConfigDebugLog implements ConfigDebugLog {
  const DeveloperConfigDebugLog();

  @override
  void reportFetchFailure(ConfigFailure failure, {StackTrace? stackTrace}) {
    developer.log(
      'vm_config: remote fetch failed: ${failure.message}',
      name: 'vm_config',
      level: 1000,
      error: failure.cause,
      stackTrace: stackTrace,
    );
  }

  @override
  void reportCacheFailure(
    Object error,
    StackTrace stackTrace, {
    required String operation,
  }) {
    developer.log(
      'vm_config: cache $operation failed: $error',
      name: 'vm_config',
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void reportTypeMismatch({
    required String key,
    required Type expected,
    required Type actual,
  }) {
    developer.log(
      'vm_config: type mismatch for "$key": expected $expected, got '
      '$actual; falling back to the default',
      name: 'vm_config',
      level: 800,
    );
  }
}
