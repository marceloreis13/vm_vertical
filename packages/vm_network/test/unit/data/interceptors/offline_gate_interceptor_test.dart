import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_network/src/data/interceptors/offline_gate_interceptor.dart';
import 'package:vm_network/vm_network.dart';

import '../../../fakes/fake_connectivity_gate.dart';
import '../../../fakes/recording_http_client_adapter.dart';

void main() {
  late Dio dio;
  late RecordingHttpClientAdapter adapter;
  late FakeConnectivityGate gate;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    adapter = RecordingHttpClientAdapter();
    dio.httpClientAdapter = adapter;
    gate = FakeConnectivityGate();
  });

  tearDown(() => gate.dispose());

  group('OfflineGateInterceptor', () {
    test('online requests proceed immediately with no gating delay', () async {
      gate.setOnline(true);
      dio.interceptors.add(
        OfflineGateInterceptor(
          gate: gate,
          policy: const OfflineRequestPolicy(),
        ),
      );
      adapter.responses = [(options) => ResponseBody.fromString('{}', 200)];

      final response = await dio.get<dynamic>('/x');

      expect(response.statusCode, 200);
      expect(adapter.requests.length, 1);
    });

    test('a request held while offline is resumed once back online', () async {
      gate.setOnline(false);
      dio.interceptors.add(
        OfflineGateInterceptor(
          gate: gate,
          policy: const OfflineRequestPolicy(maxWait: Duration(seconds: 5)),
        ),
      );
      adapter.responses = [(options) => ResponseBody.fromString('{}', 200)];

      final future = dio.get<dynamic>('/x');
      // The request should not resolve while offline.
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(adapter.requests, isEmpty);

      gate.setOnline(true);
      final response = await future;

      expect(response.statusCode, 200);
      expect(adapter.requests.length, 1);
    });

    test(
      'a bounded wait exceeded fails with a typed OfflineFailure, never a raw exception',
      () async {
        gate.setOnline(false);
        dio.interceptors.add(
          OfflineGateInterceptor(
            gate: gate,
            policy: const OfflineRequestPolicy(
              maxWait: Duration(milliseconds: 50),
            ),
          ),
        );

        try {
          await dio.get<dynamic>('/x');
          fail('expected a DioException carrying an OfflineFailure');
        } on DioException catch (exception) {
          expect(exception.error, isA<OfflineFailure>());
        }
        expect(adapter.requests, isEmpty);
      },
    );
  });
}
