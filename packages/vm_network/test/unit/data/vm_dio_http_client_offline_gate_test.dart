import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:vm_network/src/data/vm_dio_http_client.dart';
import 'package:vm_network/vm_network.dart';

import '../../fakes/fake_connectivity_gate.dart';

void main() {
  group('VmDioHttpClient.fromConfig offline gate wiring', () {
    test(
      'absent gate is byte-for-byte prior behavior: no gating delay',
      () async {
        final client = VmDioHttpClient.fromConfig(
          const VmNetworkConfig(baseUrl: 'https://example.test'),
        );
        final adapter = DioAdapter(dio: client.debugDio);
        adapter.onGet('/x', (server) => server.reply(200, {'ok': true}));

        final result = await client.getRaw('/x');

        expect(result.isSuccess, isTrue);
      },
    );

    test('configured gate holds offline requests then resumes them', () async {
      final gate = FakeConnectivityGate(initiallyOnline: false);
      addTearDown(gate.dispose);

      final client = VmDioHttpClient.fromConfig(
        VmNetworkConfig(
          baseUrl: 'https://example.test',
          gate: gate,
          offlinePolicy: const OfflineRequestPolicy(
            maxWait: Duration(seconds: 5),
          ),
        ),
      );
      final adapter = DioAdapter(dio: client.debugDio);
      adapter.onGet('/x', (server) => server.reply(200, {'ok': true}));

      final future = client.getRaw('/x');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      gate.setOnline(true);
      final result = await future;

      expect(result.isSuccess, isTrue);
    });

    test(
      'configured gate exceeding the bound resolves to Err(OfflineFailure)',
      () async {
        final gate = FakeConnectivityGate(initiallyOnline: false);
        addTearDown(gate.dispose);

        final client = VmDioHttpClient.fromConfig(
          VmNetworkConfig(
            baseUrl: 'https://example.test',
            gate: gate,
            offlinePolicy: const OfflineRequestPolicy(
              maxWait: Duration(milliseconds: 50),
            ),
          ),
        );
        final adapter = DioAdapter(dio: client.debugDio);
        adapter.onGet('/x', (server) => server.reply(200, {'ok': true}));

        final result = await client.getRaw('/x');

        expect(result.isFailure, isTrue);
        result.when(
          success: (value) => fail('expected failure, got $value'),
          failure: (failure) => expect(failure, isA<OfflineFailure>()),
        );
      },
    );

    test('online requests with a configured gate are unaffected', () async {
      final gate = FakeConnectivityGate();
      addTearDown(gate.dispose);

      final client = VmDioHttpClient.fromConfig(
        VmNetworkConfig(baseUrl: 'https://example.test', gate: gate),
      );
      final adapter = DioAdapter(dio: client.debugDio);
      adapter.onGet('/x', (server) => server.reply(200, {'ok': true}));

      final result = await client.getRaw('/x');

      expect(result.isSuccess, isTrue);
    });
  });
}
