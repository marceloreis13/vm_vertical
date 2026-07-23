import '../core/failure.dart';
import '../core/result.dart';

/// Persistence for sensitive string values (tokens, credentials), hardened
/// relative to [KeyValueStore]. A distinct type so sensitive access sites are
/// explicit at the call point. Uses a storage namespace that never overlaps
/// with `KeyValueStore` — a value written here can never be read back through
/// it.
abstract class SecureStore {
  Future<Result<void, StorageFailure>> set(String key, String value);

  Future<Result<String, StorageFailure>> get(String key);

  Future<Result<void, StorageFailure>> remove(String key);

  Future<Result<bool, StorageFailure>> containsKey(String key);

  Future<Result<void, StorageFailure>> clear();
}
