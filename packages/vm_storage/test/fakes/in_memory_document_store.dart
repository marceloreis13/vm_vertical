// ignore_for_file: prefer_initializing_formals
// (field is private for encapsulation; the constructor's named parameter
// must stay public, so a plain initializing formal isn't available here.)

import 'package:vm_storage/vm_storage.dart';

class _Record<T> {
  _Record(this.value, {this.expiresAt});

  final T value;
  final DateTime? expiresAt;
  DateTime? deletedAt;
}

/// In-memory `DocumentStore<T>` fake for tests. Honors TTL and soft-delete
/// semantics identically to the Hive-backed implementation.
class InMemoryDocumentStore<T> implements DocumentStore<T> {
  InMemoryDocumentStore({
    required DocumentKeyOf<T> keyOf,
    this.defaultTtl,
    this.softDeleteEnabled = false,
  }) : _keyOf = keyOf;

  final DocumentKeyOf<T> _keyOf;
  final Duration? defaultTtl;
  final bool softDeleteEnabled;
  final Map<String, _Record<T>> _records = {};

  bool _isExpired(_Record<T> record) =>
      record.expiresAt != null && DateTime.now().isAfter(record.expiresAt!);

  @override
  Future<Result<void, StorageFailure>> put(T value, {Duration? ttl}) async {
    final effectiveTtl = ttl ?? defaultTtl;
    _records[_keyOf(value)] = _Record(
      value,
      expiresAt: effectiveTtl == null ? null : DateTime.now().add(effectiveTtl),
    );
    return const Success(null);
  }

  @override
  Future<Result<T, StorageFailure>> get(String key) async {
    final record = _records[key];
    if (record == null) {
      return Err(StorageFailure.notFound(message: 'Record "$key" not found'));
    }
    if (_isExpired(record)) {
      _records.remove(key);
      return Err(StorageFailure.notFound(message: 'Record "$key" has expired'));
    }
    if (softDeleteEnabled && record.deletedAt != null) {
      return Err(StorageFailure.notFound(message: 'Record "$key" was deleted'));
    }
    return Success(record.value);
  }

  @override
  Future<Result<List<T>, StorageFailure>> getAll() async {
    final expired = <String>[];
    final items = <T>[];
    for (final entry in _records.entries) {
      if (_isExpired(entry.value)) {
        expired.add(entry.key);
        continue;
      }
      if (softDeleteEnabled && entry.value.deletedAt != null) continue;
      items.add(entry.value.value);
    }
    for (final key in expired) {
      _records.remove(key);
    }
    return Success(items);
  }

  @override
  Future<Result<void, StorageFailure>> delete(String key) async {
    if (softDeleteEnabled) {
      _records[key]?.deletedAt = DateTime.now();
    } else {
      _records.remove(key);
    }
    return const Success(null);
  }

  @override
  Future<Result<void, StorageFailure>> clear() async {
    _records.clear();
    return const Success(null);
  }

  @override
  Future<Result<void, StorageFailure>> purge() async {
    _records.removeWhere((_, record) => record.deletedAt != null);
    return const Success(null);
  }
}
