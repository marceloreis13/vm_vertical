import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_localization/src/data/locale/in_memory_locale_repository.dart';
import 'package:vm_localization/vm_localization.dart';

void main() {
  const supportedLocales = [Locale('pt', 'BR'), Locale('en')];
  const config = VmLocalizationConfig(
    supportedLocales: supportedLocales,
    defaultLocale: Locale('pt', 'BR'),
  );

  group('VmLocaleCubit', () {
    test('startup with a valid saved locale resolves to that locale', () async {
      final repository = InMemoryLocaleRepository();
      await repository.save(const Locale('en'));
      final cubit = VmLocaleCubit(config: config, repository: repository);

      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.locale, const Locale('en'));
    });

    test(
      'startup with no saved locale resolves to the config default',
      () async {
        final cubit = VmLocaleCubit(
          config: config,
          repository: InMemoryLocaleRepository(),
        );

        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.locale, const Locale('pt', 'BR'));
      },
    );

    test(
      'startup with an unsupported saved locale falls back to the config default',
      () async {
        final repository = InMemoryLocaleRepository();
        await repository.save(const Locale('fr'));
        final cubit = VmLocaleCubit(config: config, repository: repository);

        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.locale, const Locale('pt', 'BR'));
      },
    );

    test('changing to a supported locale emits and persists', () async {
      final repository = InMemoryLocaleRepository();
      final cubit = VmLocaleCubit(config: config, repository: repository);
      await Future<void>.delayed(Duration.zero);

      await cubit.changeLocale(const Locale('en'));

      expect(cubit.state.locale, const Locale('en'));
      final saved = await repository.getSaved();
      expect(
        saved.when(success: (locale) => locale, failure: (_) => null),
        const Locale('en'),
      );
    });

    test('changing to an unsupported locale is a no-op', () async {
      final repository = InMemoryLocaleRepository();
      final cubit = VmLocaleCubit(config: config, repository: repository);
      await Future<void>.delayed(Duration.zero);

      await cubit.changeLocale(const Locale('fr'));

      expect(cubit.state.locale, const Locale('pt', 'BR'));
      final saved = await repository.getSaved();
      expect(
        saved.when(success: (locale) => locale, failure: (_) => null),
        isNull,
      );
    });
  });
}
