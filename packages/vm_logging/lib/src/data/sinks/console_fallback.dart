import 'dart:developer' as developer;

/// Reports a sink failure caught during fan-out isolation. Kept separate
/// from [ConsoleLogSink] so a failure is visible in dev even when the
/// console sink itself isn't registered, without ever rethrowing.
void reportSinkFailure(Object sink, Object error, StackTrace stackTrace) {
  developer.log(
    'vm_logging: sink $sink threw while handling an entry: $error',
    name: 'vm_logging',
    level: 1000,
    error: error,
    stackTrace: stackTrace,
  );
}
