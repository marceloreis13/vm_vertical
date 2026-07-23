import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_network/src/data/interceptors/default_headers_interceptor.dart';

import '../../../fakes/recording_http_client_adapter.dart';

void main() {
  late Dio dio;
  late RecordingHttpClientAdapter adapter;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    adapter = RecordingHttpClientAdapter();
    dio.httpClientAdapter = adapter;
    dio.interceptors.add(
      DefaultHeadersInterceptor(
        defaultHeaders: {'Accept': 'application/json', 'X-App': 'vm_core'},
      ),
    );
  });

  group('DefaultHeadersInterceptor', () {
    test('applies configured default headers when not overridden', () async {
      await dio.get<dynamic>('/x');

      expect(adapter.requests.single.headers['Accept'], 'application/json');
      expect(adapter.requests.single.headers['X-App'], 'vm_core');
    });

    test('per-call header overrides the default', () async {
      await dio.get<dynamic>(
        '/x',
        options: Options(headers: {'Accept': 'text/plain'}),
      );

      expect(adapter.requests.single.headers['Accept'], 'text/plain');
    });
  });
}
