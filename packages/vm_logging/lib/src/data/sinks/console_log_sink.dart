// ignore_for_file: prefer_initializing_formals
// (the field is private for encapsulation; the constructor's named
// parameter must stay public, so a plain initializing formal isn't
// available here.)

import 'dart:async';
import 'dart:developer' as developer;

import '../../domain/log_entry.dart';
import '../../domain/log_level.dart';
import '../../domain/log_sink.dart';

/// Built-in sink that writes each entry via `dart:developer` and exposes an
/// **observable** record of received entries (a broadcast [Stream] plus a
/// bounded [buffer]) so a UI — the `example/` visual demo — can render
/// emitted logs on-screen live.
class ConsoleLogSink implements LogSink {
  ConsoleLogSink({int bufferLimit = 200}) : _bufferLimit = bufferLimit;

  final int _bufferLimit;
  final List<LogEntry> _buffer = [];
  final StreamController<LogEntry> _controller =
      StreamController<LogEntry>.broadcast();

  /// Entries received so far, oldest first, capped at `bufferLimit`.
  List<LogEntry> get buffer => List.unmodifiable(_buffer);

  /// Emits each entry as it is received, in order.
  Stream<LogEntry> get entries => _controller.stream;

  @override
  void handle(LogEntry entry) {
    developer.log(
      _describe(entry),
      name: 'vm_logging',
      level: _developerLevel(entry.level),
      error: entry.error,
      stackTrace: entry.stackTrace,
    );
    _buffer.add(entry);
    if (_buffer.length > _bufferLimit) {
      _buffer.removeAt(0);
    }
    if (!_controller.isClosed) {
      _controller.add(entry);
    }
  }

  String _describe(LogEntry entry) =>
      '[${entry.level.name}] ${entry.message}'
      '${entry.fields.isEmpty ? '' : ' ${entry.fields}'}';

  /// Maps onto `dart:developer`'s 0-2000 severity scale (mirrors
  /// `package:logging`'s levels).
  int _developerLevel(LogLevel level) => switch (level) {
    LogLevel.trace => 300,
    LogLevel.debug => 500,
    LogLevel.info => 800,
    LogLevel.warn => 900,
    LogLevel.error => 1000,
  };

  /// Releases the broadcast stream. Safe to call once the sink is no longer
  /// used (e.g. example app teardown).
  Future<void> dispose() => _controller.close();
}
