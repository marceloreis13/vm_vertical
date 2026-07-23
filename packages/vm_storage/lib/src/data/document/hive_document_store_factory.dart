// ignore_for_file: prefer_initializing_formals
// (field is private for encapsulation; the constructor's named parameter
// must stay public, so a plain initializing formal isn't available here.)

import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../domain/document_store.dart';
import '../../domain/vm_storage_config.dart';
import 'hive_document_store.dart';

/// Opens Hive CE-backed [DocumentStore]s, one box per collection (named
/// `<namespace>:<collection>`). Lazily initializes Hive on first use; never
/// leaks Hive types through the barrel.
class HiveDocumentStoreFactory implements DocumentStoreFactory {
  HiveDocumentStoreFactory({required VmStorageConfig config})
    : _config = config;

  final VmStorageConfig _config;
  static bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await Hive.initFlutter();
    _initialized = true;
  }

  @override
  Future<DocumentStore<T>> open<T>({
    required String collection,
    required DocumentEncoder<T> toJson,
    required DocumentDecoder<T> fromJson,
    required DocumentKeyOf<T> keyOf,
  }) async {
    await _ensureInitialized();
    final boxName = '${_config.namespace}:$collection';
    final box = await Hive.openBox<dynamic>(boxName);
    final options = _config.collectionOptions(collection);
    return HiveDocumentStore<T>(
      box: box,
      toJson: toJson,
      fromJson: fromJson,
      keyOf: keyOf,
      defaultTtl: options.defaultTtl,
      softDeleteEnabled: options.softDeleteEnabled,
    );
  }
}
