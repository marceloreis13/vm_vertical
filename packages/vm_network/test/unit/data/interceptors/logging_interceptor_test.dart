import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_network/src/data/interceptors/logging_interceptor.dart';
import 'package:vm_network/src/data/logging/vm_network_logger.dart';

import '../../../fakes/recording_http_client_adapter.dart';

class _RecordingLogger implements VmNetworkLogger {
  final List<String> messages = [];

  @override
  void log(String message) => messages.add(message);
}

void main() {
  late Dio dio;
  late RecordingHttpClientAdapter adapter;
  late _RecordingLogger logger;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    adapter = RecordingHttpClientAdapter();
    dio.httpClientAdapter = adapter;
    logger = _RecordingLogger();
  });

  group('LoggingInterceptor', () {
    test('logs request/response metadata when enabled', () async {
      dio.interceptors.add(LoggingInterceptor(logger: logger, enabled: true));

      await dio.get<dynamic>('/x');

      expect(logger.messages, isNotEmpty);
    });

    test('emits nothing when disabled', () async {
      dio.interceptors.add(LoggingInterceptor(logger: logger, enabled: false));

      await dio.get<dynamic>('/x');

      expect(logger.messages, isEmpty);
    });

    test(
      'redacts the Authorization header value in the logged output',
      () async {
        dio.interceptors.add(LoggingInterceptor(logger: logger, enabled: true));

        await dio.get<dynamic>(
          '/x',
          options: Options(headers: {'Authorization': 'Bearer super-secret'}),
        );

        final requestLog = logger.messages.firstWhere(
          (m) => m.startsWith('-->'),
        );
        expect(requestLog.contains('super-secret'), isFalse);
        expect(requestLog.contains('***redacted***'), isTrue);
      },
    );
  });
}
