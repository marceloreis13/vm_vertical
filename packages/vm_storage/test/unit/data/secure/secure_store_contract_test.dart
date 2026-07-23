import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vm_storage/src/data/key_value/shared_preferences_key_value_store.dart';
import 'package:vm_storage/vm_storage.dart';

import '../../../fakes/in_memory_secure_store.dart';

/// `flutter_secure_storage` requires a real Keychain/Keystore, so it is
/// smoke-tested via the visual example (see design.md, "Risks / Trade-offs")
/// rather than mocked here. These tests exercise the `SecureStore` contract
/// against the in-memory fake, plus the cross-store isolation guarantee
/// against the real `KeyValueStore` backend.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<T> unwrap<T>(Future<Result<T, StorageFailure>> future) async {
    final result = await future;
    return result.when(
      success: (value) => value,
      failure: (failure) => throw StateError('unexpected failure: $failure'),
    );
  }

  group('SecureStore contract', () {
    test('stores and retrieves a token', () async {
      final store = InMemorySecureStore();

      await unwrap<void>(store.set('access_token', 'abc123'));
      final value = await unwrap<String>(store.get('access_token'));

      expect(value, 'abc123');
    });

    test('reading a missing secure key returns not-found', () async {
      final store = InMemorySecureStore();

      final result = await store.get('missing');

      expect(
        result.when(
          success: (_) => null,
          failure: (StorageFailure failure) => failure,
        ),
        isA<StorageNotFoundFailure>(),
      );
    });
  });

  group('Sensitive data isolation', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test(
      'a value written via SecureStore is not readable via KeyValueStore',
      () async {
        final secureStore = InMemorySecureStore();
        final keyValueStore = SharedPreferencesKeyValueStore(namespace: 'app');

        await unwrap<void>(secureStore.set('token', 'super-secret'));
        final result = await keyValueStore.get<String>('token');

        expect(
          result.when(success: (_) => null, failure: (failure) => failure),
          isA<StorageNotFoundFailure>(),
        );
      },
    );
  });
}
