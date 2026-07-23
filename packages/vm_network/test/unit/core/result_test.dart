import 'package:flutter_test/flutter_test.dart';
import 'package:vm_network/vm_network.dart';

void main() {
  group('Result', () {
    test('Success carries the value and folds to the success branch', () {
      const result = Success<int, String>(42);

      final folded = result.when(
        success: (value) => 'ok:$value',
        failure: (failure) => 'err:$failure',
      );

      expect(folded, 'ok:42');
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
    });

    test('Err carries the typed error and folds to the failure branch', () {
      const result = Err<int, String>('boom');

      final folded = result.when(
        success: (value) => 'ok:$value',
        failure: (failure) => 'err:$failure',
      );

      expect(folded, 'err:boom');
      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
    });

    test('map transforms the success value only', () {
      const success = Success<int, String>(2);
      const err = Err<int, String>('boom');

      expect(
        success
            .map((value) => value * 10)
            .when(success: (value) => value, failure: (failure) => -1),
        20,
      );
      expect(
        err
            .map((value) => value * 10)
            .when(success: (value) => value, failure: (failure) => -1),
        -1,
      );
    });
  });
}
