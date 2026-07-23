import 'log_level.dart';

/// An immutable, fully-formed log entry: the [level] and [message] a
/// consumer logged, [fields] merged from base/child/per-call context, an
/// emission [timestamp], and the optional [error]/[stackTrace] carried by
/// `warn`/`error` calls.
///
/// A [LogEntry] only reaches a [LogSink] after redaction — see
/// `logging-redaction`.
class LogEntry {
  LogEntry({
    required this.level,
    required this.message,
    required Map<String, Object?> fields,
    required this.timestamp,
    this.error,
    this.stackTrace,
  }) : fields = Map.unmodifiable(fields);

  final LogLevel level;
  final String message;
  final Map<String, Object?> fields;
  final DateTime timestamp;
  final Object? error;
  final StackTrace? stackTrace;

  /// Returns a copy with [message]/[fields] replaced, keeping everything
  /// else — used by the redaction pipeline to produce the redacted entry
  /// actually delivered to sinks.
  LogEntry copyWith({String? message, Map<String, Object?>? fields}) {
    return LogEntry(
      level: level,
      message: message ?? this.message,
      fields: fields ?? this.fields,
      timestamp: timestamp,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() =>
      'LogEntry(level: $level, message: $message, fields: $fields, '
      'timestamp: $timestamp, error: $error)';
}
