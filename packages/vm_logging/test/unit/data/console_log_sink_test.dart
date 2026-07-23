import 'package:flutter_test/flutter_test.dart';
import 'package:vm_logging/vm_logging.dart';

LogEntry _entry(String message) => LogEntry(
  level: LogLevel.info,
  message: message,
  fields: const {},
  timestamp: DateTime(2026),
);

void main() {
  test('noop sink discards every entry without side effects', () {
    const sink = NoopLogSink();

    expect(() => sink.handle(_entry('anything')), returnsNormally);
  });

  group('ConsoleLogSink', () {
    test('buffers received entries in order', () {
      final sink = ConsoleLogSink();

      sink.handle(_entry('first'));
      sink.handle(_entry('second'));

      expect(sink.buffer.map((e) => e.message), ['first', 'second']);
    });

    test('emits each entry on its observable stream, in order', () async {
      final sink = ConsoleLogSink();
      final received = <String>[];
      final subscription = sink.entries.listen(
        (entry) => received.add(entry.message),
      );

      sink.handle(_entry('first'));
      sink.handle(_entry('second'));
      await Future<void>.delayed(Duration.zero);

      expect(received, ['first', 'second']);
      await subscription.cancel();
      await sink.dispose();
    });
  });
}
