import 'log_entry.dart';

/// Pluggable destination port. A [LogSink] receives a fully-formed,
/// already-redacted [LogEntry] and is solely responsible for delivering it
/// to its destination. Any number of sinks may be registered without
/// changing [Logger] or its call sites.
///
/// A sink must handle any asynchronous work internally — the fan-out that
/// calls [handle] does not await it. A throwing [handle] is caught and
/// isolated by the fan-out; it must never be relied on to propagate.
abstract class LogSink {
  void handle(LogEntry entry);
}
