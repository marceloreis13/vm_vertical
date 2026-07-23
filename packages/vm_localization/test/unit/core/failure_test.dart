import 'package:flutter_test/flutter_test.dart';
import 'package:vm_localization/vm_localization.dart';

void main() {
  group('LocalizationFailure taxonomy', () {
    test('persistenceBackend carries message and cause', () {
      const failure = LocalizationFailure.persistenceBackend(
        message: 'boom',
        cause: 'x',
      );

      expect(failure.message, 'boom');
      expect(failure.cause, 'x');
    });

    test('unsupportedLocale carries message and cause', () {
      const failure = LocalizationFailure.unsupportedLocale(
        message: 'not supported',
        cause: 'x',
      );

      expect(failure.message, 'not supported');
      expect(failure.cause, 'x');
    });

    test('each variant is exhaustively matchable', () {
      final failures = <LocalizationFailure>[
        const LocalizationFailure.persistenceBackend(message: 'a'),
        const LocalizationFailure.unsupportedLocale(message: 'b'),
      ];

      final matched = failures.map((failure) {
        return switch (failure) {
          LocalizationPersistenceBackendFailure() => 'persistenceBackend',
          LocalizationUnsupportedLocaleFailure() => 'unsupportedLocale',
        };
      }).toList();

      expect(matched, ['persistenceBackend', 'unsupportedLocale']);
    });
  });
}
