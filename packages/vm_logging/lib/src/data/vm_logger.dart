// ignore_for_file: prefer_initializing_formals
// (fields are private for encapsulation; the constructor's named parameters
// must stay public, so a plain initializing formal isn't available here.)

import '../domain/log_entry.dart';
import '../domain/log_level.dart';
import '../domain/logger.dart';
import '../domain/vm_logging_config.dart';
import 'redaction/redaction_pipeline.dart';
import 'sinks/console_fallback.dart';

/// The `Logger` implementation: builds an immutable [LogEntry] per call,
/// redacts it, then fans it out to every registered sink whose `minLevel`
/// it meets. Every call is synchronous, returns `void`, and never throws —
/// build → redact → fan-out all run inside this class, each sink wrapped in
/// its own `try/catch` (see `logging-sinks`).
///
/// [forContext] returns a child that binds fixed [_boundFields] merged over
/// this logger's own context; merge precedence at emit time is base <
/// bound < per-call fields, most specific wins.
class VmLogger implements Logger {
  VmLogger({
    required List<SinkRegistration> sinks,
    required RedactionPipeline redaction,
    Map<String, Object?> boundFields = const {},
  }) : _sinks = sinks,
       _redaction = redaction,
       _boundFields = boundFields;

  final List<SinkRegistration> _sinks;
  final RedactionPipeline _redaction;
  final Map<String, Object?> _boundFields;

  @override
  void trace(String message, {Map<String, Object?> fields = const {}}) =>
      _emit(LogLevel.trace, message, fields: fields);

  @override
  void debug(String message, {Map<String, Object?> fields = const {}}) =>
      _emit(LogLevel.debug, message, fields: fields);

  @override
  void info(String message, {Map<String, Object?> fields = const {}}) =>
      _emit(LogLevel.info, message, fields: fields);

  @override
  void warn(
    String message, {
    Map<String, Object?> fields = const {},
    Object? error,
    StackTrace? stackTrace,
  }) => _emit(
    LogLevel.warn,
    message,
    fields: fields,
    error: error,
    stackTrace: stackTrace,
  );

  @override
  void error(
    String message, {
    Map<String, Object?> fields = const {},
    Object? error,
    StackTrace? stackTrace,
  }) => _emit(
    LogLevel.error,
    message,
    fields: fields,
    error: error,
    stackTrace: stackTrace,
  );

  @override
  Logger forContext(Map<String, Object?> fields) => VmLogger(
    sinks: _sinks,
    redaction: _redaction,
    boundFields: {..._boundFields, ...fields},
  );

  void _emit(
    LogLevel level,
    String message, {
    required Map<String, Object?> fields,
    Object? error,
    StackTrace? stackTrace,
  }) {
    try {
      if (_sinks.isEmpty) return;
      final entry = LogEntry(
        level: level,
        message: message,
        fields: {..._boundFields, ...fields},
        timestamp: DateTime.now(),
        error: error,
        stackTrace: stackTrace,
      );
      final redacted = _redaction.apply(entry);
      for (final registration in _sinks) {
        if (redacted.level < registration.minLevel) continue;
        try {
          registration.sink.handle(redacted);
        } catch (sinkError, sinkStackTrace) {
          reportSinkFailure(registration.sink, sinkError, sinkStackTrace);
        }
      }
    } catch (_) {
      // Build/redaction failure: the call contract is non-throwing no
      // matter what, so swallow rather than let it escape the call site.
    }
  }
}
