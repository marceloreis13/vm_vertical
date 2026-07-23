import '../core/failure.dart';
import '../core/result.dart';

/// Runs [action], translating any thrown error into a
/// [LocalizationFailure.persistenceBackend] instead of letting it propagate.
/// Single translation point used by every `LocaleRepository` implementation
/// so a raw backend exception never crosses the module boundary.
Future<Result<T, LocalizationFailure>> guardLocalizationCall<T>(
  Future<T> Function() action,
) async {
  try {
    final value = await action();
    return Success(value);
  } catch (error) {
    return Err(
      LocalizationFailure.persistenceBackend(
        message: 'Locale persistence backend error: $error',
        cause: error,
      ),
    );
  }
}
