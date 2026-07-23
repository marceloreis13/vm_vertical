import 'package:flutter/widgets.dart';

/// Configuration for the `vm_localization` module, always supplied by the
/// consuming app via `registerVmLocalizationModule`. The module hard-codes
/// no supported-locale list, no default locale and reads no global/ambient
/// state.
class VmLocalizationConfig {
  const VmLocalizationConfig({
    required this.supportedLocales,
    required this.defaultLocale,
    this.enablePersistence = false,
  });

  /// Every locale the app supports. `defaultLocale` must be a member.
  final List<Locale> supportedLocales;

  /// Used at startup when no locale was saved, or when a saved locale is no
  /// longer in [supportedLocales].
  final Locale defaultLocale;

  /// When `true`, the module registers a `LocaleRepository` backed by
  /// `vm_storage`'s `KeyValueStore`; otherwise an in-memory implementation
  /// is registered (resets on every app restart).
  final bool enablePersistence;
}
