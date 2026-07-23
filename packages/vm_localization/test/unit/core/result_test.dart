import 'package:flutter_test/flutter_test.dart';
import 'package:vm_localization/vm_localization.dart';

void main() {
  group('Result', () {
    test('Success carries its value and folds through success branch', () {
      const result = Success<int, String>(42);

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.when(success: (v) => v, failure: (_) => -1), 42);
    });

    test('Err carries its value and folds through failure branch', () {
      const result = Err<int, String>('boom');

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.when(success: (_) => -1, failure: (f) => f), 'boom');
    });

    test('map transforms a success value, leaves a failure untouched', () {
      const success = Success<int, String>(2);
      const failure = Err<int, String>('boom');

      expect(
        success.map((v) => v * 10).when(success: (v) => v, failure: (_) => -1),
        20,
      );
      expect(
        failure.map((v) => v * 10).when(success: (_) => -1, failure: (f) => f),
        'boom',
      );
    });
  });
}
