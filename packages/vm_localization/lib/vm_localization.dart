/// vm_localization: runtime locale switching and locale-aware formatting
/// for the vm_core platform. Injected supported locales/default locale, a
/// Cubit the app's `MaterialApp` observes, a `LocaleRepository` with an
/// in-memory default and an optional `vm_storage`-backed implementation, and
/// `intl`-based date/number/currency formatting.
library;

export 'src/core/failure.dart';
export 'src/core/result.dart';
export 'src/data/di/vm_localization_registration.dart';
export 'src/domain/formatting.dart';
export 'src/domain/locale_repository.dart';
export 'src/domain/vm_localization_config.dart';
export 'src/presentation/demo/screen/vm_localization_demo_screen.dart';
export 'src/presentation/locale/vm_locale_cubit.dart';
export 'src/presentation/locale/vm_locale_state.dart';
