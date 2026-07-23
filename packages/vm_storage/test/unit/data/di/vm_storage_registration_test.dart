import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vm_storage/vm_storage.dart';

void main() {
  late GetIt getIt;

  setUp(() {
    getIt = GetIt.asNewInstance();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('registerVmStorageModule', () {
    test(
      'registering with only key-value enabled resolves only that store',
      () {
        registerVmStorageModule(
          getIt,
          config: const VmStorageConfig(namespace: 'app'),
        );

        expect(getIt<KeyValueStore>(), isA<KeyValueStore>());
        expect(getIt.isRegistered<SecureStore>(), isFalse);
        expect(getIt.isRegistered<DocumentStoreFactory>(), isFalse);
      },
    );

    test('registering with all stores opted-in resolves all three', () {
      registerVmStorageModule(
        getIt,
        config: const VmStorageConfig(
          namespace: 'app',
          enableSecureStore: true,
          documentCollections: [VmDocumentCollectionConfig(name: 'notes')],
        ),
      );

      expect(getIt<KeyValueStore>(), isA<KeyValueStore>());
      expect(getIt<SecureStore>(), isA<SecureStore>());
      expect(getIt<DocumentStoreFactory>(), isA<DocumentStoreFactory>());
    });

    test('two namespaces isolate the same bare key from each other', () async {
      final getItA = GetIt.asNewInstance();
      final getItB = GetIt.asNewInstance();
      registerVmStorageModule(
        getItA,
        config: const VmStorageConfig(namespace: 'app-a'),
      );
      registerVmStorageModule(
        getItB,
        config: const VmStorageConfig(namespace: 'app-b'),
      );

      await getItA<KeyValueStore>().set('flag', 'a-value');
      await getItB<KeyValueStore>().set('flag', 'b-value');

      final resultA = await getItA<KeyValueStore>().get<String>('flag');
      final resultB = await getItB<KeyValueStore>().get<String>('flag');

      expect(resultA.when(success: (v) => v, failure: (_) => null), 'a-value');
      expect(resultB.when(success: (v) => v, failure: (_) => null), 'b-value');

      await getItA.reset();
      await getItB.reset();
    });
  });
}
