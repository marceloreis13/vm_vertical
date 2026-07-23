import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_network/src/data/interceptors/custom_interceptor_adapter.dart';
import 'package:vm_network/vm_network.dart';

import '../../../fakes/recording_http_client_adapter.dart';

class _AddHeaderInterceptor extends VmNetworkInterceptor {
  _AddHeaderInterceptor(this.headerName, this.headerValue, this.log);

  final String headerName;
  final String headerValue;
  final List<String> log;

  @override
  Future<void> onRequest(VmRequestContext request) async {
    log.add(headerName);
    request.headers[headerName] = headerValue;
  }
}

void main() {
  late Dio dio;
  late RecordingHttpClientAdapter adapter;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    adapter = RecordingHttpClientAdapter();
    dio.httpClientAdapter = adapter;
  });

  group('CustomInterceptorAdapter', () {
    test(
      'a custom interceptor can add a header without any Dio import in the consumer',
      () async {
        final log = <String>[];
        dio.interceptors.add(
          CustomInterceptorAdapter(_AddHeaderInterceptor('X-Custom', '1', log)),
        );

        await dio.get<dynamic>('/x');

        expect(adapter.requests.single.headers['X-Custom'], '1');
      },
    );

    test('two custom interceptors run in the supplied order', () async {
      final log = <String>[];
      dio.interceptors.addAll([
        CustomInterceptorAdapter(_AddHeaderInterceptor('X-First', 'a', log)),
        CustomInterceptorAdapter(_AddHeaderInterceptor('X-Second', 'b', log)),
      ]);

      await dio.get<dynamic>('/x');

      expect(log, ['X-First', 'X-Second']);
      expect(adapter.requests.single.headers['X-First'], 'a');
      expect(adapter.requests.single.headers['X-Second'], 'b');
    });
  });
}
