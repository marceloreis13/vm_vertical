import 'package:flutter_test/flutter_test.dart';
import 'package:vm_storage/src/data/failure_translator.dart';
import 'package:vm_storage/vm_storage.dart';

void main() {
  group('guardStorageCall', () {
    test('returns Success when the action completes', () async {
      final result = await guardStorageCall(() async => 'value');

      expect(
        result.when(success: (value) => value, failure: (_) => 'failed'),
        'value',
      );
    });

    test('maps a thrown error to a backend StorageFailure', () async {
      final result = await guardStorageCall<String>(() async {
        throw StateError('boom');
      });

      final failure = result.when(
        success: (_) => throw StateError('expected failure'),
        failure: (failure) => failure,
      );

      expect(failure, isA<StorageBackendFailure>());
    });
  });
}
