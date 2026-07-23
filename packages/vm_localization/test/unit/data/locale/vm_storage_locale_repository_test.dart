import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_localization/src/data/locale/vm_storage_locale_repository.dart';

import '../../../fakes/in_memory_key_value_store.dart';

void main() {
  group('VmStorageLocaleRepository', () {
    test('getSaved with nothing saved returns success with null', () async {
      final repository = VmStorageLocaleRepository(
        store: InMemoryKeyValueStore(),
      );

      final result = await repository.getSaved();

      expect(
        result.when(success: (locale) => locale, failure: (_) => 'error'),
        isNull,
      );
    });

    test(
      'save then getSaved roundtrips the locale via KeyValueStore',
      () async {
        final repository = VmStorageLocaleRepository(
          store: InMemoryKeyValueStore(),
        );

        await repository.save(const Locale('pt', 'BR'));
        final result = await repository.getSaved();

        expect(
          result.when(success: (locale) => locale, failure: (_) => null),
          const Locale('pt', 'BR'),
        );
      },
    );
  });
}
