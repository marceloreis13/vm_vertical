import 'package:vm_storage/vm_storage.dart';

/// In-memory `KeyValueStore` fake for tests. Honors the same not-found and
/// type-mismatch semantics as the `shared_preferences` backend.
class InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, Object> _values = {};

  @override
  Future<Result<void, StorageFailure>> set<T extends Object>(
    String key,
    T value,
  ) async {
    _values[key] = value;
    return const Success(null);
  }

  @override
  Future<Result<T, StorageFailure>> get<T extends Object>(String key) async {
    if (!_values.containsKey(key)) {
      return Err(StorageFailure.notFound(message: 'Key "$key" not found'));
    }
    final value = _values[key];
    if (value is! T) {
      return Err(
        StorageFailure.serialization(
          message: 'Stored value for "$key" is not a $T',
        ),
      );
    }
    return Success(value);
  }

  @override
  Future<Result<void, StorageFailure>> remove(String key) async {
    _values.remove(key);
    return const Success(null);
  }

  @override
  Future<Result<bool, StorageFailure>> containsKey(String key) async {
    return Success(_values.containsKey(key));
  }

  @override
  Future<Result<void, StorageFailure>> clear() async {
    _values.clear();
    return const Success(null);
  }
}
