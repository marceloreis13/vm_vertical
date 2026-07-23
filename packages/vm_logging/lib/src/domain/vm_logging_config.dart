import 'log_level.dart';
import 'log_sink.dart';
import 'redactor.dart';

/// Pairs a [LogSink] with its own [minLevel] threshold: the fan-out
/// delivers an entry to [sink] only when `entry.level >= minLevel`.
class SinkRegistration {
  const SinkRegistration({required this.sink, required this.minLevel});

  final LogSink sink;
  final LogLevel minLevel;
}

/// Configuration for the `vm_logging` module, always supplied by the
/// consuming app via `registerVmLogging`. The module hard-codes no
/// app-specific sink, level, sensitive key or redactor.
class VmLoggingConfig {
  const VmLoggingConfig({
    this.sinks = const [],
    this.sensitiveKeys = const {},
    this.redactors = const [],
  });

  /// Registered sinks with their per-sink [SinkRegistration.minLevel].
  /// Empty means logging is a safe no-op.
  final List<SinkRegistration> sinks;

  /// Field keys (matched case-insensitively) whose values are always
  /// replaced by a redaction placeholder before reaching any sink.
  final Set<String> sensitiveKeys;

  /// Additional redactors applied, in order, over field values and the
  /// message.
  final List<Redactor> redactors;
}
