import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_network/src/data/vm_dio_http_client.dart';
import 'package:vm_network/vm_network.dart';

import '../../../fakes/recording_http_client_adapter.dart';

class _AddHeaderInterceptor extends VmNetworkInterceptor {
  _AddHeaderInterceptor(this.headerName, this.headerValue);

  final String headerName;
  final String headerValue;

  @override
  Future<void> onRequest(VmRequestContext request) async {
    request.headers[headerName] = headerValue;
  }
}

void main() {
  late GetIt getIt;

  setUp(() {
    getIt = GetIt.asNewInstance();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('registerVmNetworkModule', () {
    test('resolves the VmHttpClient abstraction', () {
      registerVmNetworkModule(
        getIt,
        config: const VmNetworkConfig(baseUrl: 'https://example.test'),
      );

      expect(getIt<VmHttpClient>(), isA<VmHttpClient>());
    });

    test(
      'config values (baseUrl) drive the resolved client behavior',
      () async {
        registerVmNetworkModule(
          getIt,
          config: const VmNetworkConfig(baseUrl: 'https://configured.test'),
        );

        final client = getIt<VmHttpClient>() as VmDioHttpClient;
        final adapter = RecordingHttpClientAdapter();
        client.debugDio.httpClientAdapter = adapter;

        await client.getRaw('/ping');

        expect(adapter.requests.single.baseUrl, 'https://configured.test');
      },
    );

    test('config custom interceptors reach the resolved client', () async {
      registerVmNetworkModule(
        getIt,
        config: VmNetworkConfig(
          baseUrl: 'https://example.test',
          customInterceptors: [_AddHeaderInterceptor('X-Custom', 'yes')],
        ),
      );

      final client = getIt<VmHttpClient>() as VmDioHttpClient;
      final adapter = RecordingHttpClientAdapter();
      client.debugDio.httpClientAdapter = adapter;

      await client.getRaw('/ping');

      expect(adapter.requests.single.headers['X-Custom'], 'yes');
    });

    test('with no custom interceptors, only built-ins run', () async {
      registerVmNetworkModule(
        getIt,
        config: const VmNetworkConfig(baseUrl: 'https://example.test'),
      );

      final client = getIt<VmHttpClient>() as VmDioHttpClient;
      final adapter = RecordingHttpClientAdapter();
      client.debugDio.httpClientAdapter = adapter;

      await client.getRaw('/ping');

      expect(
        adapter.requests.single.headers.containsKey('Authorization'),
        isFalse,
      );
    });
  });
}
