import '../core/failure.dart';
import '../core/result.dart';

/// String-keyed persistence for light values (preferences and flags), hiding
/// the concrete backend. Supports `String`, `bool`, `int`, `double` and
/// `List<String>` values. Delete is always physical — no tombstone.
abstract class KeyValueStore {
  Future<Result<void, StorageFailure>> set<T extends Object>(
    String key,
    T value,
  );

  Future<Result<T, StorageFailure>> get<T extends Object>(String key);

  Future<Result<void, StorageFailure>> remove(String key);

  Future<Result<bool, StorageFailure>> containsKey(String key);

  Future<Result<void, StorageFailure>> clear();
}
