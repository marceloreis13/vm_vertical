import 'package:get_it/get_it.dart';
import 'package:vm_storage/vm_storage.dart' as vm_storage;

import '../../domain/formatting.dart';
import '../../domain/locale_repository.dart';
import '../../domain/vm_localization_config.dart';
import '../../presentation/locale/vm_locale_cubit.dart';
import '../formatting/intl_formatters.dart';
import '../locale/in_memory_locale_repository.dart';
import '../locale/vm_storage_locale_repository.dart';

/// Single registration entry point for `vm_localization`. Receives its
/// [config] from the consuming app — nothing here is hard-coded.
/// `LocaleRepository` is registered selectively: in-memory by default, or
/// `vm_storage`-backed when [VmLocalizationConfig.enablePersistence] is set
/// (requires `vm_storage` to already be registered in [getIt]).
void registerVmLocalizationModule(
  GetIt getIt, {
  required VmLocalizationConfig config,
}) {
  getIt.registerSingleton<VmLocalizationConfig>(config);

  getIt.registerSingleton<LocaleRepository>(
    config.enablePersistence
        ? VmStorageLocaleRepository(store: getIt<vm_storage.KeyValueStore>())
        : InMemoryLocaleRepository(),
  );

  getIt.registerSingleton<VmLocaleCubit>(
    VmLocaleCubit(config: config, repository: getIt<LocaleRepository>()),
    dispose: (cubit) => cubit.close(),
  );

  getIt.registerSingleton<VmDateFormatter>(const IntlDateFormatter());
  getIt.registerSingleton<VmNumberFormatter>(const IntlNumberFormatter());
  getIt.registerSingleton<VmCurrencyFormatter>(const IntlCurrencyFormatter());
}
