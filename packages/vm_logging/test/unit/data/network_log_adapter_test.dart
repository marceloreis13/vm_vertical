import 'package:flutter_test/flutter_test.dart';
import 'package:vm_logging/vm_logging.dart';
import 'package:vm_logging/src/data/redaction/redaction_pipeline.dart';
import 'package:vm_logging/src/data/vm_logger.dart';

import '../../fakes/fake_log_sink.dart';

void main() {
  late FakeLogSink sink;
  late Logger logger;
  late NetworkLogAdapter adapter;

  setUp(() {
    sink = FakeLogSink();
    logger = VmLogger(
      sinks: [SinkRegistration(sink: sink, minLevel: LogLevel.trace)],
      redaction: const RedactionPipeline(
        sensitiveKeys: {'authorization'},
        redactors: [],
      ),
    );
    adapter = NetworkLogAdapter(logger);
  });

  test('logs a request without referencing any vm_network type', () {
    adapter.logExchange(
      method: 'GET',
      url: 'https://api.example.com/ping',
      statusCode: 200,
    );

    final entry = sink.received.single;
    expect(entry.message, contains('GET https://api.example.com/ping'));
    expect(entry.fields['statusCode'], 200);
    expect(entry.level, LogLevel.info);
  });

  test('a sensitive header is masked in the delivered entry', () {
    adapter.logExchange(
      method: 'POST',
      url: 'https://api.example.com/login',
      statusCode: 401,
      headers: {'Authorization': 'Bearer secret-token'},
    );

    final headers = sink.received.single.fields['headers'] as Map;
    expect(headers['Authorization'], kRedactionPlaceholder);
  });

  test('a 5xx status or transport error logs at error level', () {
    adapter.logExchange(
      method: 'GET',
      url: 'https://api.example.com/down',
      statusCode: 503,
    );

    expect(sink.received.single.level, LogLevel.error);
  });

  test('a 4xx status logs at warn level', () {
    adapter.logExchange(
      method: 'GET',
      url: 'https://api.example.com/missing',
      statusCode: 404,
    );

    expect(sink.received.single.level, LogLevel.warn);
  });
}
