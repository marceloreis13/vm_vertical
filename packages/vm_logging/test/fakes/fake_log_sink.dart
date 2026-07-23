// ignore_for_file: prefer_initializing_formals
// (the field is private for encapsulation; the constructor's named
// parameter must stay public, so a plain initializing formal isn't
// available here.)

import 'package:vm_logging/vm_logging.dart';

/// Records every entry it receives, in order. Can be made to throw on
/// [handle] to exercise per-sink error isolation.
class FakeLogSink implements LogSink {
  FakeLogSink({bool throwsOnHandle = false}) : _throwsOnHandle = throwsOnHandle;

  final bool _throwsOnHandle;
  final List<LogEntry> received = [];

  @override
  void handle(LogEntry entry) {
    if (_throwsOnHandle) {
      throw StateError('FakeLogSink configured to throw');
    }
    received.add(entry);
  }
}
