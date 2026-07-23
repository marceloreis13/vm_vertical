import 'package:flutter/widgets.dart';

import '../../core/failure.dart';
import '../../core/result.dart';
import '../../domain/locale_repository.dart';

/// Default `LocaleRepository`: holds the saved locale only in process
/// memory. Registered when the app doesn't opt into `vm_storage`-backed
/// persistence — the chosen locale resets to
/// `VmLocalizationConfig.defaultLocale` on every app restart.
class InMemoryLocaleRepository implements LocaleRepository {
  Locale? _saved;

  @override
  Future<Result<Locale?, LocalizationFailure>> getSaved() async {
    return Success(_saved);
  }

  @override
  Future<Result<void, LocalizationFailure>> save(Locale locale) async {
    _saved = locale;
    return const Success(null);
  }
}
