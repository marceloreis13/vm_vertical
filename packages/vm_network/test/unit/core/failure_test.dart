import 'package:flutter_test/flutter_test.dart';
import 'package:vm_network/vm_network.dart';

void main() {
  group('Failure taxonomy', () {
    test('NetworkFailure carries message and cause', () {
      final failure = NetworkFailure(message: 'no connectivity', cause: 'x');

      expect(failure.message, 'no connectivity');
      expect(failure.cause, 'x');
    });

    test('TimeoutFailure carries message and cause', () {
      final failure = TimeoutFailure(message: 'timed out', cause: 'x');

      expect(failure.message, 'timed out');
      expect(failure.cause, 'x');
    });

    test('ServerFailure carries statusCode and optional payload', () {
      final failure = ServerFailure(
        message: 'server error',
        statusCode: 500,
        payload: {'error': 'boom'},
      );

      expect(failure.statusCode, 500);
      expect(failure.payload, {'error': 'boom'});
    });

    test('ParsingFailure carries message and cause', () {
      final failure = ParsingFailure(message: 'bad body', cause: 'x');

      expect(failure.message, 'bad body');
      expect(failure.cause, 'x');
    });

    test('UnauthorizedFailure carries statusCode', () {
      final failure = UnauthorizedFailure(
        message: 'unauthorized',
        statusCode: 401,
      );

      expect(failure.statusCode, 401);
    });

    test('UnknownFailure carries message and cause', () {
      final failure = UnknownFailure(message: 'mystery', cause: 'x');

      expect(failure.message, 'mystery');
      expect(failure.cause, 'x');
    });

    test('OfflineFailure carries message and cause', () {
      final failure = OfflineFailure(message: 'held too long', cause: 'x');

      expect(failure.message, 'held too long');
      expect(failure.cause, 'x');
    });

    test('each variant is a distinct Failure subtype', () {
      final failures = <Failure>[
        const NetworkFailure(message: 'a'),
        const TimeoutFailure(message: 'b'),
        const ServerFailure(message: 'c', statusCode: 500),
        const ParsingFailure(message: 'd'),
        const UnauthorizedFailure(message: 'e', statusCode: 401),
        const UnknownFailure(message: 'f'),
        const OfflineFailure(message: 'g'),
      ];

      final matched = failures.map((failure) {
        return switch (failure) {
          NetworkFailure() => 'network',
          TimeoutFailure() => 'timeout',
          ServerFailure() => 'server',
          ParsingFailure() => 'parsing',
          UnauthorizedFailure() => 'unauthorized',
          UnknownFailure() => 'unknown',
          OfflineFailure() => 'offline',
        };
      }).toList();

      expect(matched, [
        'network',
        'timeout',
        'server',
        'parsing',
        'unauthorized',
        'unknown',
        'offline',
      ]);
    });
  });
}
