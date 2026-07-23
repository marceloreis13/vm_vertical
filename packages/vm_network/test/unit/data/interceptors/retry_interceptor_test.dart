import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_network/src/data/interceptors/retry_interceptor.dart';
import 'package:vm_network/vm_network.dart';

import '../../../fakes/recording_http_client_adapter.dart';

void main() {
  late Dio dio;
  late RecordingHttpClientAdapter adapter;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    adapter = RecordingHttpClientAdapter();
    dio.httpClientAdapter = adapter;
  });

  group('RetryInterceptor', () {
    test('a transient timeout is retried and then succeeds', () async {
      dio.interceptors.add(
        RetryInterceptor(
          dio: dio,
          policy: RetryPolicy(maxAttempts: 2, backoff: (_) => Duration.zero),
        ),
      );
      adapter.responses = [
        (options) => throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
        ),
        (options) => ResponseBody.fromString('{"ok":true}', 200),
      ];

      final response = await dio.get<dynamic>('/x');

      expect(response.statusCode, 200);
      expect(adapter.requests.length, 2);
    });

    test('retries are exhausted and the last failure is returned', () async {
      dio.interceptors.add(
        RetryInterceptor(
          dio: dio,
          policy: RetryPolicy(maxAttempts: 2, backoff: (_) => Duration.zero),
        ),
      );
      adapter.responses = [
        (options) => throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
        ),
      ];

      await expectLater(dio.get<dynamic>('/x'), throwsA(isA<DioException>()));
      expect(adapter.requests.length, 2);
    });

    test('a non-retriable (401) failure is not retried', () async {
      dio.interceptors.add(
        RetryInterceptor(
          dio: dio,
          policy: RetryPolicy(maxAttempts: 3, backoff: (_) => Duration.zero),
        ),
      );
      adapter.responses = [
        (options) => throw DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(requestOptions: options, statusCode: 401),
        ),
      ];

      await expectLater(dio.get<dynamic>('/x'), throwsA(isA<DioException>()));
      expect(adapter.requests.length, 1);
    });
  });
}
