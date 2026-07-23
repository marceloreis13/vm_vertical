import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_network/src/data/failure_translator.dart';
import 'package:vm_network/vm_network.dart';

RequestOptions _options() => RequestOptions(path: '/x');

void main() {
  group('translateDioException', () {
    test('connectionTimeout maps to TimeoutFailure', () {
      final exception = DioException(
        requestOptions: _options(),
        type: DioExceptionType.connectionTimeout,
      );

      expect(translateDioException(exception), isA<TimeoutFailure>());
    });

    test('receiveTimeout maps to TimeoutFailure', () {
      final exception = DioException(
        requestOptions: _options(),
        type: DioExceptionType.receiveTimeout,
      );

      expect(translateDioException(exception), isA<TimeoutFailure>());
    });

    test('connectionError maps to NetworkFailure', () {
      final exception = DioException(
        requestOptions: _options(),
        type: DioExceptionType.connectionError,
      );

      expect(translateDioException(exception), isA<NetworkFailure>());
    });

    test('401 response maps to UnauthorizedFailure', () {
      final exception = DioException(
        requestOptions: _options(),
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: _options(),
          statusCode: 401,
        ),
      );

      final failure = translateDioException(exception);

      expect(failure, isA<UnauthorizedFailure>());
      expect((failure as UnauthorizedFailure).statusCode, 401);
    });

    test('403 response maps to UnauthorizedFailure', () {
      final exception = DioException(
        requestOptions: _options(),
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: _options(),
          statusCode: 403,
        ),
      );

      expect(translateDioException(exception), isA<UnauthorizedFailure>());
    });

    test('non-2xx response maps to ServerFailure carrying status code', () {
      final exception = DioException(
        requestOptions: _options(),
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: _options(),
          statusCode: 500,
          data: {'error': 'boom'},
        ),
      );

      final failure = translateDioException(exception);

      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 500);
      expect(failure.payload, {'error': 'boom'});
    });

    test('unclassified error maps to UnknownFailure and never throws', () {
      final exception = DioException(
        requestOptions: _options(),
        type: DioExceptionType.unknown,
      );

      expect(() => translateDioException(exception), returnsNormally);
      expect(translateDioException(exception), isA<UnknownFailure>());
    });
  });
}
