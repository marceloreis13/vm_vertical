import 'package:flutter_test/flutter_test.dart';
import 'package:vm_storage/vm_storage.dart';

void main() {
  group('StorageFailure taxonomy', () {
    test('notFound carries message and cause', () {
      const failure = StorageFailure.notFound(message: 'missing', cause: 'x');

      expect(failure.message, 'missing');
      expect(failure.cause, 'x');
    });

    test('serialization carries message and cause', () {
      const failure = StorageFailure.serialization(
        message: 'bad codec',
        cause: 'x',
      );

      expect(failure.message, 'bad codec');
      expect(failure.cause, 'x');
    });

    test('backend carries message and cause', () {
      const failure = StorageFailure.backend(message: 'boom', cause: 'x');

      expect(failure.message, 'boom');
      expect(failure.cause, 'x');
    });

    test('security carries message and cause', () {
      const failure = StorageFailure.security(
        message: 'keychain denied',
        cause: 'x',
      );

      expect(failure.message, 'keychain denied');
      expect(failure.cause, 'x');
    });

    test('capabilityUnsupported carries message and cause', () {
      const failure = StorageFailure.capabilityUnsupported(
        message: 'not supported',
        cause: 'x',
      );

      expect(failure.message, 'not supported');
      expect(failure.cause, 'x');
    });

    test('each variant is exhaustively matchable', () {
      final failures = <StorageFailure>[
        const StorageFailure.notFound(message: 'a'),
        const StorageFailure.serialization(message: 'b'),
        const StorageFailure.backend(message: 'c'),
        const StorageFailure.security(message: 'd'),
        const StorageFailure.capabilityUnsupported(message: 'e'),
      ];

      final matched = failures.map((failure) {
        return switch (failure) {
          StorageNotFoundFailure() => 'notFound',
          StorageSerializationFailure() => 'serialization',
          StorageBackendFailure() => 'backend',
          StorageSecurityFailure() => 'security',
          StorageCapabilityUnsupportedFailure() => 'capabilityUnsupported',
        };
      }).toList();

      expect(matched, [
        'notFound',
        'serialization',
        'backend',
        'security',
        'capabilityUnsupported',
      ]);
    });
  });
}
