import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_localization/src/data/locale/in_memory_locale_repository.dart';

void main() {
  group('InMemoryLocaleRepository', () {
    test('getSaved with nothing saved returns success with null', () async {
      final repository = InMemoryLocaleRepository();

      final result = await repository.getSaved();

      expect(
        result.when(success: (locale) => locale, failure: (_) => 'error'),
        isNull,
      );
    });

    test('save then getSaved roundtrips the locale', () async {
      final repository = InMemoryLocaleRepository();

      await repository.save(const Locale('pt', 'BR'));
      final result = await repository.getSaved();

      expect(
        result.when(success: (locale) => locale, failure: (_) => null),
        const Locale('pt', 'BR'),
      );
    });
  });
}
