import 'package:vm_storage/vm_storage.dart';

/// In-memory `SecureStore` fake for tests. Uses its own map, distinct from
/// [InMemoryKeyValueStore], so cross-store isolation can be exercised without
/// a real secure backend.
class InMemorySecureStore implements SecureStore {
  final Map<String, String> _values = {};

  @override
  Future<Result<void, StorageFailure>> set(String key, String value) async {
    _values[key] = value;
    return const Success(null);
  }

  @override
  Future<Result<String, StorageFailure>> get(String key) async {
    final value = _values[key];
    if (value == null) {
      return Err(StorageFailure.notFound(message: 'Key "$key" not found'));
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
