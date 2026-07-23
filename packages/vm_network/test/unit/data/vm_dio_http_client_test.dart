import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:vm_network/src/data/vm_dio_http_client.dart';
import 'package:vm_network/vm_network.dart';

class _TestModel {
  const _TestModel(this.id);

  factory _TestModel.fromJson(Object? json) {
    final map = json as Map<String, dynamic>;
    return _TestModel(map['id'] as int);
  }

  final int id;
}

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late VmDioHttpClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;
    client = VmDioHttpClient(dio);
  });

  group('VmDioHttpClient', () {
    test('decodes a successful response via the caller decoder', () async {
      adapter.onGet('/users/1', (server) => server.reply(200, {'id': 1}));

      final result = await client.get<_TestModel>(
        '/users/1',
        decoder: _TestModel.fromJson,
      );

      expect(result.isSuccess, isTrue);
      result.when(
        success: (value) => expect(value.id, 1),
        failure: (failure) => fail('expected success, got $failure'),
      );
    });

    test('getRaw returns the undecoded map without a model decoder', () async {
      adapter.onGet(
        '/users/1',
        (server) => server.reply(200, {'id': 1, 'name': 'ada'}),
      );

      final result = await client.getRaw('/users/1');

      expect(result.isSuccess, isTrue);
      result.when(
        success: (value) => expect(value, {'id': 1, 'name': 'ada'}),
        failure: (failure) => fail('expected success, got $failure'),
      );
    });

    test('decoder throwing on malformed body returns ParsingFailure', () async {
      adapter.onGet(
        '/users/1',
        (server) => server.reply(200, {'unexpected': true}),
      );

      final result = await client.get<_TestModel>(
        '/users/1',
        decoder: _TestModel.fromJson,
      );

      expect(result.isFailure, isTrue);
      result.when(
        success: (value) => fail('expected failure, got $value'),
        failure: (failure) => expect(failure, isA<ParsingFailure>()),
      );
    });

    test(
      'transport error is translated into a typed Failure, not thrown',
      () async {
        adapter.onGet(
          '/missing',
          (server) => server.reply(404, {'error': 'not found'}),
        );

        final result = await client.getRaw('/missing');

        expect(result.isFailure, isTrue);
        result.when(
          success: (value) => fail('expected failure, got $value'),
          failure: (failure) => expect(failure, isA<ServerFailure>()),
        );
      },
    );
  });
}
