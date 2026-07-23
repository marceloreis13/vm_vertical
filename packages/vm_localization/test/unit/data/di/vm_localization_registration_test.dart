import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vm_localization/vm_localization.dart';
import 'package:vm_storage/vm_storage.dart' as vm_storage;

void main() {
  late GetIt getIt;

  setUp(() {
    getIt = GetIt.asNewInstance();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('registerVmLocalizationModule', () {
    const config = VmLocalizationConfig(
      supportedLocales: [Locale('pt', 'BR'), Locale('en')],
      defaultLocale: Locale('pt', 'BR'),
    );

    test(
      'registering without persistence resolves the in-memory repository',
      () {
        registerVmLocalizationModule(getIt, config: config);

        expect(getIt<LocaleRepository>(), isA<LocaleRepository>());
        expect(getIt<VmLocaleCubit>(), isA<VmLocaleCubit>());
      },
    );

    test(
      'registering with persistence resolves a vm_storage-backed repository',
      () {
        vm_storage.registerVmStorageModule(
          getIt,
          config: const vm_storage.VmStorageConfig(namespace: 'app'),
        );

        registerVmLocalizationModule(
          getIt,
          config: const VmLocalizationConfig(
            supportedLocales: [Locale('pt', 'BR'), Locale('en')],
            defaultLocale: Locale('pt', 'BR'),
            enablePersistence: true,
          ),
        );

        expect(getIt<LocaleRepository>(), isA<LocaleRepository>());
      },
    );

    test(
      'config drives registration: a different config yields a different resolved default',
      () {
        registerVmLocalizationModule(
          getIt,
          config: const VmLocalizationConfig(
            supportedLocales: [Locale('fr'), Locale('de')],
            defaultLocale: Locale('de'),
          ),
        );

        expect(getIt<VmLocaleCubit>().state.locale, const Locale('de'));
        expect(getIt<VmLocaleCubit>().state.supportedLocales, [
          const Locale('fr'),
          const Locale('de'),
        ]);
      },
    );
  });
}
