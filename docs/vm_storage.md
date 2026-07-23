# `vm_storage`

Local persistence for the vm_core platform: three typed, injectable stores
behind stable interfaces — `KeyValueStore`, `SecureStore`, `DocumentStore<T>`.
Every operation returns a typed `Result<S, StorageFailure>` — not-found,
serialization, backend, security and capability-unsupported errors are always
typed, never raw exceptions. The underlying backends (`shared_preferences`,
`flutter_secure_storage`, Hive CE) are implementation details: no backend
type crosses the barrel.

## Register at app startup

```dart
registerVmStorageModule(
  getIt,
  config: const VmStorageConfig(
    namespace: 'my_app', // prefixes every key/collection, transparently
    enableKeyValueStore: true, // default
    enableSecureStore: true, // optional, default false
    documentCollections: [
      VmDocumentCollectionConfig(
        name: 'notes',
        defaultTtl: Duration(hours: 1), // optional, per-put override wins
        softDeleteEnabled: true, // optional, default false
      ),
    ],
  ),
);
```

`namespace` is the only required field. `SecureStore` and the document store
are opted into per app — a minimal app pulls in no secure-storage/Hive
weight it does not use. Nothing here is hard-coded inside the module.

## Key-value store

```dart
final store = getIt<KeyValueStore>();

await store.set('theme', 'dark');
final result = await store.get<String>('theme');

result.when(
  success: (value) => print('theme: $value'),
  failure: (failure) => switch (failure) {
    StorageNotFoundFailure() => print('not set yet'),
    _ => print('unexpected: ${failure.message}'),
  },
);

await store.remove('theme'); // physical delete, no tombstone
```

Supports `String`, `bool`, `int`, `double` and `List<String>` values.
Backed by `shared_preferences`.

## Secure store

Same shape, hardened for sensitive strings (tokens, credentials). A distinct
type from `KeyValueStore` so sensitive access sites are explicit, backed by
`flutter_secure_storage` in its own namespace — a value written here can
never be read back through `KeyValueStore`.

```dart
final secure = getIt<SecureStore>();

await secure.set('access_token', token);
final result = await secure.get('access_token');
```

## Document store

Typed collections for structured/cache data, with an injected codec (so the
module never imports a consumer model) and a `keyOf` function:

```dart
final factory = getIt<DocumentStoreFactory>();

final notes = await factory.open<Note>(
  collection: 'notes',
  toJson: (note) => note.toJson(),
  fromJson: Note.fromJson,
  keyOf: (note) => note.id,
);

await notes.put(note); // uses the collection's configured default TTL
await notes.put(note, ttl: const Duration(minutes: 5)); // per-write override

final result = await notes.get(note.id);
final all = await notes.getAll(); // all live (non-expired, non-tombstoned)
```

- **TTL**: an entry whose TTL has elapsed reads as not-found and is evicted
  lazily on access.
- **Soft-delete** (when `softDeleteEnabled` is set for the collection):
  `delete` writes a `deletedAt` tombstone; `get`/`getAll` exclude it;
  `purge()` physically removes tombstoned records. When disabled, `delete`
  is always physical.

Backed by Hive CE, one box per `<namespace>:<collection>`.

## Visual example

`packages/vm_storage/example/` is a standalone Flutter app (no `apps/`
dependency) demonstrating all three stores: preferences CRUD, a secure
token, and a document collection with TTL and soft-delete. The demo screen
(`StorageDemoScreen`) lives in `lib/` and is exported by the barrel, so any
app can embed it directly via `package:vm_storage/vm_storage.dart` — the
`example/` app is only a thin shell that registers the module and runs it.

## Local `Result`/`StorageFailure`

`Result<S, F>` and the sealed `StorageFailure` taxonomy are defined locally
in `lib/src/core/`, isolated so a future `vm_foundation` migration is a
re-home rather than a rewrite. Consumers should only depend on the
barrel-exported types, not reach into `lib/src/`.
