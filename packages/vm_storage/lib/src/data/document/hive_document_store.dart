// ignore_for_file: prefer_initializing_formals
// (fields are private for encapsulation; the constructor's named parameters
// must stay public, so a plain initializing formal isn't available here.)

import 'package:hive_ce/hive.dart';

import '../../core/failure.dart';
import '../../core/result.dart';
import '../../domain/document_store.dart';

/// Marks a codec (`toJson`/`fromJson`) failure so it is reported as
/// [StorageFailure.serialization] rather than the generic backend variant.
class _CodecError {
  _CodecError(this.cause);

  final Object cause;
}

/// `DocumentStore<T>` backed by a Hive CE box. Each record is stored as a
/// wrapper map (`data`/`expiresAt`/`deletedAt`) so TTL and soft-delete
/// metadata travel alongside the encoded value. Never leaks `Box`/Hive types
/// through the barrel.
class HiveDocumentStore<T> implements DocumentStore<T> {
  HiveDocumentStore({
    required Box<dynamic> box,
    required DocumentEncoder<T> toJson,
    required DocumentDecoder<T> fromJson,
    required DocumentKeyOf<T> keyOf,
    required this.defaultTtl,
    required this.softDeleteEnabled,
  }) : _box = box,
       _toJson = toJson,
       _fromJson = fromJson,
       _keyOf = keyOf;

  final Box<dynamic> _box;
  final DocumentEncoder<T> _toJson;
  final DocumentDecoder<T> _fromJson;
  final DocumentKeyOf<T> _keyOf;
  final Duration? defaultTtl;
  final bool softDeleteEnabled;

  @override
  Future<Result<void, StorageFailure>> put(T value, {Duration? ttl}) async {
    try {
      final effectiveTtl = ttl ?? defaultTtl;
      final record = <String, dynamic>{
        'data': _encode(value),
        'expiresAt': effectiveTtl == null
            ? null
            : DateTime.now().add(effectiveTtl).millisecondsSinceEpoch,
        'deletedAt': null,
      };
      await _box.put(_keyOf(value), record);
      return const Success(null);
    } on _CodecError catch (error) {
      return Err(
        StorageFailure.serialization(
          message: 'Failed to encode record',
          cause: error.cause,
        ),
      );
    } catch (error) {
      return Err(
        StorageFailure.backend(
          message: 'Storage backend error: $error',
          cause: error,
        ),
      );
    }
  }

  @override
  Future<Result<T, StorageFailure>> get(String key) async {
    try {
      final raw = _box.get(key);
      if (raw == null) {
        return Err(StorageFailure.notFound(message: 'Record "$key" not found'));
      }
      final record = Map<String, dynamic>.from(raw as Map);
      if (_isExpired(record)) {
        await _box.delete(key);
        return Err(
          StorageFailure.notFound(message: 'Record "$key" has expired'),
        );
      }
      if (softDeleteEnabled && record['deletedAt'] != null) {
        return Err(
          StorageFailure.notFound(message: 'Record "$key" was deleted'),
        );
      }
      return Success(_decode(record));
    } on _CodecError catch (error) {
      return Err(
        StorageFailure.serialization(
          message: 'Failed to decode record "$key"',
          cause: error.cause,
        ),
      );
    } catch (error) {
      return Err(
        StorageFailure.backend(
          message: 'Storage backend error: $error',
          cause: error,
        ),
      );
    }
  }

  @override
  Future<Result<List<T>, StorageFailure>> getAll() async {
    try {
      final items = <T>[];
      final expiredKeys = <dynamic>[];
      for (final key in _box.keys) {
        final raw = _box.get(key);
        if (raw == null) continue;
        final record = Map<String, dynamic>.from(raw as Map);
        if (_isExpired(record)) {
          expiredKeys.add(key);
          continue;
        }
        if (softDeleteEnabled && record['deletedAt'] != null) continue;
        items.add(_decode(record));
      }
      for (final key in expiredKeys) {
        await _box.delete(key);
      }
      return Success(items);
    } on _CodecError catch (error) {
      return Err(
        StorageFailure.serialization(
          message: 'Failed to decode a record',
          cause: error.cause,
        ),
      );
    } catch (error) {
      return Err(
        StorageFailure.backend(
          message: 'Storage backend error: $error',
          cause: error,
        ),
      );
    }
  }

  @override
  Future<Result<void, StorageFailure>> delete(String key) async {
    try {
      if (softDeleteEnabled) {
        final raw = _box.get(key);
        if (raw == null) return const Success(null);
        final record = Map<String, dynamic>.from(raw as Map)
          ..['deletedAt'] = DateTime.now().millisecondsSinceEpoch;
        await _box.put(key, record);
      } else {
        await _box.delete(key);
      }
      return const Success(null);
    } catch (error) {
      return Err(
        StorageFailure.backend(
          message: 'Storage backend error: $error',
          cause: error,
        ),
      );
    }
  }

  @override
  Future<Result<void, StorageFailure>> clear() async {
    try {
      await _box.clear();
      return const Success(null);
    } catch (error) {
      return Err(
        StorageFailure.backend(
          message: 'Storage backend error: $error',
          cause: error,
        ),
      );
    }
  }

  @override
  Future<Result<void, StorageFailure>> purge() async {
    try {
      final keysToDelete = <dynamic>[];
      for (final key in _box.keys) {
        final raw = _box.get(key);
        if (raw == null) continue;
        final record = Map<String, dynamic>.from(raw as Map);
        if (record['deletedAt'] != null) keysToDelete.add(key);
      }
      for (final key in keysToDelete) {
        await _box.delete(key);
      }
      return const Success(null);
    } catch (error) {
      return Err(
        StorageFailure.backend(
          message: 'Storage backend error: $error',
          cause: error,
        ),
      );
    }
  }

  Map<String, dynamic> _encode(T value) {
    try {
      return _toJson(value);
    } on _CodecError {
      rethrow;
    } catch (error) {
      throw _CodecError(error);
    }
  }

  T _decode(Map<String, dynamic> record) {
    try {
      return _fromJson(Map<String, dynamic>.from(record['data'] as Map));
    } on _CodecError {
      rethrow;
    } catch (error) {
      throw _CodecError(error);
    }
  }

  bool _isExpired(Map<String, dynamic> record) {
    final expiresAt = record['expiresAt'] as int?;
    if (expiresAt == null) return false;
    return DateTime.now().millisecondsSinceEpoch >= expiresAt;
  }
}
