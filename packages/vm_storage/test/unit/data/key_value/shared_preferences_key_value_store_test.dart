import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vm_storage/src/data/key_value/shared_preferences_key_value_store.dart';
import 'package:vm_storage/vm_storage.dart';

import '../../../fakes/in_memory_key_value_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<T> unwrap<T>(Future<Result<T, StorageFailure>> future) async {
    final result = await future;
    return result.when(
      success: (value) => value,
      failure: (failure) => throw StateError('unexpected failure: $failure'),
    );
  }

  group('SharedPreferencesKeyValueStore', () {
    test('writes then reads a value', () async {
      final store = SharedPreferencesKeyValueStore(namespace: 'app');

      await unwrap(store.set('theme', 'dark'));
      final value = await unwrap(store.get<String>('theme'));

      expect(value, 'dark');
    });

    test('reading a missing key returns not-found', () async {
      final store = SharedPreferencesKeyValueStore(namespace: 'app');

      final result = await store.get<String>('missing');

      expect(
        result.when(success: (_) => null, failure: (failure) => failure),
        isA<StorageNotFoundFailure>(),
      );
    });

    test('remove physically deletes the value', () async {
      final store = SharedPreferencesKeyValueStore(namespace: 'app');
      await unwrap(store.set('flag', true));

      await unwrap(store.remove('flag'));
      final containsKey = await unwrap(store.containsKey('flag'));

      expect(containsKey, isFalse);
    });

    test('clear only removes keys within its own namespace', () async {
      final storeA = SharedPreferencesKeyValueStore(namespace: 'app-a');
      final storeB = SharedPreferencesKeyValueStore(namespace: 'app-b');
      await unwrap(storeA.set('flag', 'a-value'));
      await unwrap(storeB.set('flag', 'b-value'));

      await unwrap(storeA.clear());

      expect((await storeA.containsKey('flag')).isSuccess, isTrue);
      expect(await unwrap(storeA.containsKey('flag')), isFalse);
      expect(await unwrap(storeB.get<String>('flag')), 'b-value');
    });
  });

  group('KeyValueStore backend-swap contract', () {
    Future<void> exercises(KeyValueStore store) async {
      await unwrap(store.set('k', 'v'));
      expect(await unwrap(store.get<String>('k')), 'v');
      expect(await unwrap(store.containsKey('k')), isTrue);
      await unwrap(store.remove('k'));
      expect(await unwrap(store.containsKey('k')), isFalse);
    }

    test(
      'shared_preferences backend and in-memory fake behave the same',
      () async {
        await exercises(SharedPreferencesKeyValueStore(namespace: 'contract'));
        await exercises(InMemoryKeyValueStore());
      },
    );
  });
}
