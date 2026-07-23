import 'package:flutter/widgets.dart';

import '../core/failure.dart';
import '../core/result.dart';

/// Reads and persists the user's chosen locale. No implementation detail of
/// the backing store (in-memory, `vm_storage`) leaks through this interface.
abstract class LocaleRepository {
  /// Returns the previously saved locale, or a successful `Result` carrying
  /// `null` when nothing was ever saved — not an error.
  Future<Result<Locale?, LocalizationFailure>> getSaved();

  Future<Result<void, LocalizationFailure>> save(Locale locale);
}
