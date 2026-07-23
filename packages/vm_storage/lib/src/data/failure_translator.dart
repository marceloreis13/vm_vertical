import '../core/failure.dart';
import '../core/result.dart';

/// Runs [action], translating any thrown error into a backend
/// [StorageFailure] instead of letting it propagate. Single translation
/// point used by every store implementation so a raw backend exception never
/// crosses the module boundary.
///
/// Store implementations that need a more specific variant (e.g.
/// [StorageFailure.serialization] for a codec error, [StorageFailure.notFound]
/// for a missing key) catch that case before falling back to this generic
/// guard.
Future<Result<T, StorageFailure>> guardStorageCall<T>(
  Future<T> Function() action,
) async {
  try {
    final value = await action();
    return Success(value);
  } catch (error) {
    return Err(
      StorageFailure.backend(
        message: 'Storage backend error: $error',
        cause: error,
      ),
    );
  }
}
