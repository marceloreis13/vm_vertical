// ignore_for_file: prefer_initializing_formals
// (field is private for encapsulation; the constructor's named parameter
// must stay public, so a plain initializing formal isn't available here.)

import 'package:flutter/widgets.dart';
import 'package:vm_storage/vm_storage.dart' as vm_storage;

import '../../core/failure.dart';
import '../../core/result.dart';
import '../../domain/locale_repository.dart';
import '../failure_translator.dart';

/// `LocaleRepository` backed by `vm_storage`'s `KeyValueStore`. Registered
/// when the app opts into persistence via `VmLocalizationConfig`. The saved
/// locale is stored as its language/country tag (e.g. `pt_BR`) under a single
/// key; never leaks `KeyValueStore` through this interface.
class VmStorageLocaleRepository implements LocaleRepository {
  VmStorageLocaleRepository({required vm_storage.KeyValueStore store})
    : _store = store;

  static const _key = 'vm_localization.locale';

  final vm_storage.KeyValueStore _store;

  @override
  Future<Result<Locale?, LocalizationFailure>> getSaved() {
    return guardLocalizationCall(() async {
      final result = await _store.get<String>(_key);
      return result.when(
        success: (tag) => _localeFromTag(tag),
        failure: (_) => null,
      );
    });
  }

  @override
  Future<Result<void, LocalizationFailure>> save(Locale locale) {
    return guardLocalizationCall(() async {
      final result = await _store.set(_key, _tagFromLocale(locale));
      result.when(success: (_) {}, failure: (failure) => throw failure);
    });
  }

  static String _tagFromLocale(Locale locale) {
    final countryCode = locale.countryCode;
    return countryCode == null || countryCode.isEmpty
        ? locale.languageCode
        : '${locale.languageCode}_$countryCode';
  }

  static Locale _localeFromTag(String tag) {
    final parts = tag.split('_');
    return parts.length > 1
        ? Locale(parts.first, parts.sublist(1).join('_'))
        : Locale(parts.first);
  }
}
