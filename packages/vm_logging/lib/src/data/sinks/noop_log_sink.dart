import '../../domain/log_entry.dart';
import '../../domain/log_sink.dart';

/// Built-in sink that accepts every entry and does nothing. Used for
/// prod-silent runs and tests.
class NoopLogSink implements LogSink {
  const NoopLogSink();

  @override
  void handle(LogEntry entry) {}
}
