import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_network/src/data/interceptors/auth_token_interceptor.dart';

import '../../../fakes/recording_http_client_adapter.dart';

void main() {
  late Dio dio;
  late RecordingHttpClientAdapter adapter;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    adapter = RecordingHttpClientAdapter();
    dio.httpClientAdapter = adapter;
  });

  group('AuthTokenInterceptor', () {
    test('attaches Authorization when the provider returns a token', () async {
      dio.interceptors.add(
        AuthTokenInterceptor(
          tokenProvider: () async => 'abc123',
          scheme: 'Bearer',
        ),
      );

      await dio.get<dynamic>('/x');

      expect(adapter.requests.single.headers['Authorization'], 'Bearer abc123');
    });

    test('adds no header when no provider is configured', () async {
      dio.interceptors.add(
        AuthTokenInterceptor(tokenProvider: null, scheme: 'Bearer'),
      );

      await dio.get<dynamic>('/x');

      expect(
        adapter.requests.single.headers.containsKey('Authorization'),
        isFalse,
      );
    });

    test('adds no header when the provider resolves null', () async {
      dio.interceptors.add(
        AuthTokenInterceptor(tokenProvider: () async => null, scheme: 'Bearer'),
      );

      await dio.get<dynamic>('/x');

      expect(
        adapter.requests.single.headers.containsKey('Authorization'),
        isFalse,
      );
    });
  });
}
