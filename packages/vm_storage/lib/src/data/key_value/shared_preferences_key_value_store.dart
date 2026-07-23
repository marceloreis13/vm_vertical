// ignore_for_file: prefer_initializing_formals
// (field is private for encapsulation; the constructor's named parameter
// must stay public, so a plain initializing formal isn't available here.)

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/failure.dart';
import '../../core/result.dart';
import '../../domain/key_value_store.dart';
import '../failure_translator.dart';

/// `KeyValueStore` backed by `shared_preferences`. Keys are namespaced
/// transparently so consumers use bare keys. Never leaks `SharedPreferences`
/// through the barrel.
class SharedPreferencesKeyValueStore implements KeyValueStore {
  SharedPreferencesKeyValueStore({required String namespace})
    : _namespace = namespace;

  final String _namespace;

  String _namespacedKey(String key) => '$_namespace:$key';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<Result<void, StorageFailure>> set<T extends Object>(
    String key,
    T value,
  ) {
    return guardStorageCall(() async {
      final prefs = await _prefs;
      final namespacedKey = _namespacedKey(key);
      switch (value) {
        case final String value:
          await prefs.setString(namespacedKey, value);
        case final bool value:
          await prefs.setBool(namespacedKey, value);
        case final int value:
          await prefs.setInt(namespacedKey, value);
        case final double value:
          await prefs.setDouble(namespacedKey, value);
        case final List<String> value:
          await prefs.setStringList(namespacedKey, value);
        default:
          throw UnsupportedError('Unsupported KeyValueStore type: $T');
      }
    });
  }

  @override
  Future<Result<T, StorageFailure>> get<T extends Object>(String key) async {
    final prefs = await _prefs;
    final namespacedKey = _namespacedKey(key);
    if (!prefs.containsKey(namespacedKey)) {
      return Err(StorageFailure.notFound(message: 'Key "$key" not found'));
    }
    return guardStorageCall(() async {
      final value = prefs.get(namespacedKey);
      if (value is! T) {
        throw StateError('Stored value for "$key" is not a $T');
      }
      return value;
    });
  }

  @override
  Future<Result<void, StorageFailure>> remove(String key) {
    return guardStorageCall(() async {
      final prefs = await _prefs;
      await prefs.remove(_namespacedKey(key));
    });
  }

  @override
  Future<Result<bool, StorageFailure>> containsKey(String key) {
    return guardStorageCall(() async {
      final prefs = await _prefs;
      return prefs.containsKey(_namespacedKey(key));
    });
  }

  @override
  Future<Result<void, StorageFailure>> clear() {
    return guardStorageCall(() async {
      final prefs = await _prefs;
      final prefix = '$_namespace:';
      final keys = prefs.getKeys().where((key) => key.startsWith(prefix));
      for (final key in keys.toList()) {
        await prefs.remove(key);
      }
    });
  }
}
