import '../core/failure.dart';
import '../core/result.dart';

/// Encodes a record of type [T] into a JSON-shaped map. Supplied by the
/// consumer (typically a Freezed `toJson`); the module never imports a
/// consumer model.
typedef DocumentEncoder<T> = Map<String, dynamic> Function(T value);

/// Decodes a record of type [T] from a JSON-shaped map. Supplied by the
/// consumer (typically a Freezed `fromJson`).
typedef DocumentDecoder<T> = T Function(Map<String, dynamic> json);

/// Derives a record's storage key.
typedef DocumentKeyOf<T> = String Function(T value);

/// Typed collection store for structured/cache data. Reads are point-in-time
/// (`Future`-based); this change exposes no stream/reactive reads.
///
/// Supports an optional per-write TTL (falling back to the collection's
/// configured default) and, when soft-delete is enabled for the collection,
/// tombstone semantics: `delete` hides the record from `get`/`getAll` without
/// physically removing it, and [purge] hard-deletes tombstoned records.
abstract class DocumentStore<T> {
  /// Writes [value] under `keyOf(value)`. [ttl] overrides the collection's
  /// configured default for this write only.
  Future<Result<void, StorageFailure>> put(T value, {Duration? ttl});

  /// Returns a not-found failure when [key] is absent, expired, or (when
  /// soft-delete is enabled) tombstoned.
  Future<Result<T, StorageFailure>> get(String key);

  /// All live (non-expired, non-tombstoned) records in the collection.
  Future<Result<List<T>, StorageFailure>> getAll();

  /// Soft-deletes (tombstone) when the collection has soft-delete enabled;
  /// otherwise physically removes the record.
  Future<Result<void, StorageFailure>> delete(String key);

  /// Physically removes every record in the collection, including
  /// tombstones.
  Future<Result<void, StorageFailure>> clear();

  /// Physically removes tombstoned records, leaving live records untouched.
  Future<Result<void, StorageFailure>> purge();
}

/// Opens a typed [DocumentStore] for a named collection, applying that
/// collection's configured TTL default and soft-delete flag. Registered only
/// when the app opts into at least one document collection.
abstract class DocumentStoreFactory {
  Future<DocumentStore<T>> open<T>({
    required String collection,
    required DocumentEncoder<T> toJson,
    required DocumentDecoder<T> fromJson,
    required DocumentKeyOf<T> keyOf,
  });
}
