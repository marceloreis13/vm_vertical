// ignore_for_file: prefer_initializing_formals
// (field is private for encapsulation; the constructor's named parameter
// must stay public, so a plain initializing formal isn't available here.)

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/failure.dart';
import '../../core/result.dart';
import '../../domain/secure_store.dart';
import '../failure_translator.dart';

/// `SecureStore` backed by `flutter_secure_storage` (Keychain/Keystore).
/// Keys are namespaced transparently; the namespace never overlaps with
/// `KeyValueStore`'s, and the backend itself is a separate physical store.
/// Never leaks `FlutterSecureStorage` through the barrel.
class FlutterSecureStorageSecureStore implements SecureStore {
  FlutterSecureStorageSecureStore({
    required String namespace,
    FlutterSecureStorage? storage,
  }) : _namespace = namespace,
       _storage = storage ?? const FlutterSecureStorage();

  final String _namespace;
  final FlutterSecureStorage _storage;

  String _namespacedKey(String key) => '$_namespace:$key';

  @override
  Future<Result<void, StorageFailure>> set(String key, String value) {
    return guardStorageCall(
      () => _storage.write(key: _namespacedKey(key), value: value),
    ).then(_asSecurityFailure);
  }

  @override
  Future<Result<String, StorageFailure>> get(String key) async {
    final result = await guardStorageCall(
      () => _storage.read(key: _namespacedKey(key)),
    ).then(_asSecurityFailure);
    return result.when(
      success: (value) => value == null
          ? Err(StorageFailure.notFound(message: 'Key "$key" not found'))
          : Success(value),
      failure: Err.new,
    );
  }

  @override
  Future<Result<void, StorageFailure>> remove(String key) {
    return guardStorageCall(
      () => _storage.delete(key: _namespacedKey(key)),
    ).then(_asSecurityFailure);
  }

  @override
  Future<Result<bool, StorageFailure>> containsKey(String key) {
    return guardStorageCall(
      () => _storage.containsKey(key: _namespacedKey(key)),
    ).then(_asSecurityFailure);
  }

  @override
  Future<Result<void, StorageFailure>> clear() {
    return guardStorageCall(() async {
      final all = await _storage.readAll();
      final prefix = '$_namespace:';
      for (final key in all.keys.where((key) => key.startsWith(prefix))) {
        await _storage.delete(key: key);
      }
    }).then(_asSecurityFailure);
  }

  /// `flutter_secure_storage` throws platform-specific errors (keychain
  /// access denial, keystore corruption); the generic backend guard already
  /// wraps them, this only re-tags the variant as [StorageFailure.security]
  /// so callers can special-case it.
  Result<T, StorageFailure> _asSecurityFailure<T>(
    Result<T, StorageFailure> result,
  ) {
    return result.when(
      success: Success.new,
      failure: (failure) => switch (failure) {
        StorageBackendFailure(:final message, :final cause) => Err(
          StorageFailure.security(message: message, cause: cause),
        ),
        _ => Err(failure),
      },
    );
  }
}
