import 'package:flutter_test/flutter_test.dart';
import 'package:vm_logging/vm_logging.dart';
import 'package:vm_logging/src/data/redaction/redaction_pipeline.dart';
import 'package:vm_logging/src/data/vm_logger.dart';

import '../../fakes/fake_log_sink.dart';

RedactionPipeline _noRedaction() =>
    const RedactionPipeline(sensitiveKeys: {}, redactors: []);

void main() {
  group('LogLevel ordering', () {
    test('is total: trace < debug < info < warn < error', () {
      expect(LogLevel.trace < LogLevel.debug, isTrue);
      expect(LogLevel.debug < LogLevel.info, isTrue);
      expect(LogLevel.info < LogLevel.warn, isTrue);
      expect(LogLevel.warn < LogLevel.error, isTrue);
      expect(LogLevel.error >= LogLevel.error, isTrue);
      expect(LogLevel.error.compareTo(LogLevel.trace), greaterThan(0));
    });
  });

  group('VmLogger threshold filtering and fan-out', () {
    test('delivers only to sinks whose minLevel the entry meets', () {
      final verbose = FakeLogSink();
      final errorsOnly = FakeLogSink();
      final logger = VmLogger(
        sinks: [
          SinkRegistration(sink: verbose, minLevel: LogLevel.debug),
          SinkRegistration(sink: errorsOnly, minLevel: LogLevel.error),
        ],
        redaction: _noRedaction(),
      );

      logger.debug('debug entry');

      expect(verbose.received, hasLength(1));
      expect(errorsOnly.received, isEmpty);

      logger.error('error entry');

      expect(verbose.received, hasLength(2));
      expect(errorsOnly.received, hasLength(1));
    });

    test('fans out one entry to every sink that meets threshold', () {
      final a = FakeLogSink();
      final b = FakeLogSink();
      final logger = VmLogger(
        sinks: [
          SinkRegistration(sink: a, minLevel: LogLevel.trace),
          SinkRegistration(sink: b, minLevel: LogLevel.trace),
        ],
        redaction: _noRedaction(),
      );

      logger.info('hello', fields: {'id': 7});

      expect(a.received.single.message, 'hello');
      expect(b.received.single.message, 'hello');
      expect(a.received.single.fields['id'], 7);
    });
  });

  group('VmLogger error isolation', () {
    test('a throwing sink does not block delivery to other sinks', () {
      final throwing = FakeLogSink(throwsOnHandle: true);
      final healthy = FakeLogSink();
      final logger = VmLogger(
        sinks: [
          SinkRegistration(sink: throwing, minLevel: LogLevel.trace),
          SinkRegistration(sink: healthy, minLevel: LogLevel.trace),
        ],
        redaction: _noRedaction(),
      );

      expect(() => logger.info('still delivered'), returnsNormally);
      expect(healthy.received.single.message, 'still delivered');
    });

    test('zero registered sinks is a safe no-op', () {
      final logger = VmLogger(sinks: const [], redaction: _noRedaction());

      expect(() => logger.error('nothing to see'), returnsNormally);
    });
  });

  group('VmLogger.forContext', () {
    test('child logger merges bound fields over the base context', () {
      final sink = FakeLogSink();
      final logger = VmLogger(
        sinks: [SinkRegistration(sink: sink, minLevel: LogLevel.trace)],
        redaction: _noRedaction(),
      );

      final child = logger.forContext({'module': 'auth'});
      child.info('login', fields: {'id': 7});

      final entry = sink.received.single;
      expect(entry.fields['module'], 'auth');
      expect(entry.fields['id'], 7);
    });

    test('a per-call field overrides a bound child field', () {
      final sink = FakeLogSink();
      final logger = VmLogger(
        sinks: [SinkRegistration(sink: sink, minLevel: LogLevel.trace)],
        redaction: _noRedaction(),
      );

      final child = logger.forContext({'module': 'auth'});
      child.info('switch', fields: {'module': 'billing'});

      expect(sink.received.single.fields['module'], 'billing');
    });

    test('error/warn calls carry error and stackTrace', () {
      final sink = FakeLogSink();
      final logger = VmLogger(
        sinks: [SinkRegistration(sink: sink, minLevel: LogLevel.trace)],
        redaction: _noRedaction(),
      );
      final stackTrace = StackTrace.current;
      final error = StateError('boom');

      logger.error('failed', error: error, stackTrace: stackTrace);

      final entry = sink.received.single;
      expect(entry.level, LogLevel.error);
      expect(entry.error, same(error));
      expect(entry.stackTrace, same(stackTrace));
    });
  });
}
