/// Per-collection options for a `DocumentStore`: TTL default applied when a
/// `put` call does not specify its own, and whether `delete` soft-deletes
/// (tombstone) or physically removes records.
class VmDocumentCollectionConfig {
  const VmDocumentCollectionConfig({
    required this.name,
    this.defaultTtl,
    this.softDeleteEnabled = false,
  });

  final String name;
  final Duration? defaultTtl;
  final bool softDeleteEnabled;
}

/// Configuration for the `vm_storage` module, always supplied by the
/// consuming app via `registerVmStorageModule`. The module hard-codes no
/// app-specific key prefix or global state.
class VmStorageConfig {
  const VmStorageConfig({
    required this.namespace,
    this.enableKeyValueStore = true,
    this.enableSecureStore = false,
    this.documentCollections = const [],
  });

  /// Prefix applied transparently to every key/collection so two consumers
  /// sharing a device cannot collide.
  final String namespace;

  final bool enableKeyValueStore;
  final bool enableSecureStore;

  /// Declares which document collections to register and their per-collection
  /// options. Empty means the document store is not registered.
  final List<VmDocumentCollectionConfig> documentCollections;

  bool get enableDocumentStore => documentCollections.isNotEmpty;

  /// Options for [name], or defaults (no TTL, no soft-delete) when the
  /// collection was not explicitly declared.
  VmDocumentCollectionConfig collectionOptions(String name) {
    for (final collection in documentCollections) {
      if (collection.name == name) return collection;
    }
    return VmDocumentCollectionConfig(name: name);
  }
}
