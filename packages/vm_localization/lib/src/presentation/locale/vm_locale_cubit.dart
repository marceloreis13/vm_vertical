// ignore_for_file: prefer_initializing_formals
// (field is private for encapsulation; the constructor's named parameter
// must stay public, so a plain initializing formal isn't available here.)

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/locale_repository.dart';
import '../../domain/vm_localization_config.dart';
import 'vm_locale_state.dart';

/// Holds the app's active locale. The consuming app's root `MaterialApp`
/// observes this Cubit's `state.locale` for its own `locale:` property —
/// every mounted module's `Localizations`-resolved text (via each module's
/// independently generated delegate) then re-resolves for the new locale
/// without `vm_localization` addressing any other module directly.
class VmLocaleCubit extends Cubit<VmLocaleState> {
  VmLocaleCubit({
    required VmLocalizationConfig config,
    required LocaleRepository repository,
  }) : _config = config,
       _repository = repository,
       super(
         VmLocaleState(
           locale: config.defaultLocale,
           supportedLocales: config.supportedLocales,
         ),
       ) {
    unawaited(_resolveStartupLocale());
  }

  final VmLocalizationConfig _config;
  final LocaleRepository _repository;

  Future<void> _resolveStartupLocale() async {
    final result = await _repository.getSaved();
    final saved = result.when(
      success: (locale) => locale,
      failure: (_) => null,
    );
    final resolved = saved != null && state.supportedLocales.contains(saved)
        ? saved
        : _config.defaultLocale;
    if (resolved != state.locale) {
      emit(state.copyWith(locale: resolved));
    }
  }

  /// Changes the active locale. Rejects (no-op) a [locale] absent from
  /// `state.supportedLocales`; persists a successful change.
  Future<void> changeLocale(Locale locale) async {
    if (!state.supportedLocales.contains(locale)) return;
    emit(state.copyWith(locale: locale));
    await _repository.save(locale);
  }
}
