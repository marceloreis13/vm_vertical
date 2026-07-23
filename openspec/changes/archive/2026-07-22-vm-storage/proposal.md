## Why

Apps and modules in the monorepo need to persist data locally — light preferences,
sensitive tokens, and cached structured collections — but there is no shared storage
layer yet. Without one, every consumer would bind directly to `shared_preferences`,
`flutter_secure_storage`, or Hive, leak the concrete backend, and let sensitive data
drift into insecure stores. This change delivers `vm_storage`: three typed, injectable
stores behind stable interfaces, so swapping the underlying technology never touches
consumers.

## What Changes

- New `packages/vm_storage` module following the standard scaffold (barrel, `lib/src/`,
  `example/`, three test kinds, `resolution: workspace`).
- **Three typed store interfaces**, each with its own semantics — no God-interface:
  - `KeyValueStore`: simple string-keyed values for preferences/flags (`get`/`set`/
    `remove`/`containsKey`/`clear`), reference backend **`shared_preferences`**.
  - `SecureStore`: same shape, hardened for sensitive data (tokens, credentials),
    reference backend **`flutter_secure_storage`**. Sensitive data never falls into the
    non-secure store.
  - `DocumentStore<T>`: typed collection store for structured/cache data with **TTL** and
    optional **soft-delete**, reference backend **Hive CE**. Serialization uses an
    **injected codec** (`toJson`/`fromJson`) plus a `keyOf` function; consumer Freezed/Json
    models never leak into the module.
- **TTL** on `DocumentStore` only: set per write and/or as a per-collection default; an
  expired entry reads as absent and is evicted lazily.
- **Soft-delete** on `DocumentStore` only, **enabled by a flag at module registration**.
  When on, `delete` writes a tombstone (`deletedAt`) and normal reads exclude soft-deleted
  records; an explicit purge physically removes them. `KeyValueStore`/`SecureStore` delete
  is always physical.
- **Typed result + failure taxonomy** defined locally in `vm_storage` (`lib/src/core/`),
  isolated for a future migration to `vm_foundation`: a `Result<S, F>` type and a sealed
  `StorageFailure` (not-found, serialization, backend, security, capability-unsupported).
  Storage errors always arrive as typed failures, never raw exceptions.
- **Injected, selective configuration**: `VmStorageConfig` (key namespace/prefix, which
  backends to register, per-collection TTL/soft-delete options) supplied by the consuming
  app via a single DI registration entry point. Secure and document stores are **optional**
  — an app registers only the stores it needs. Keys are namespaced per app/module to avoid
  collisions.
- **Standalone `example/`** built with `vm_storyboard` components: CRUD of preferences
  (`KeyValueStore`), a secure item (`SecureStore`), and a structured collection
  (`DocumentStore`) demonstrating TTL expiry and soft-delete. Any missing generic UI
  component is promoted to `vm_storyboard`.
- Living docs: register `vm_storage` in `docs/` per project rule.

## Capabilities

### New Capabilities
- `key-value-store`: string-keyed preference/flag persistence with a stable
  `get`/`set`/`remove`/`containsKey`/`clear` API, hiding the concrete backend.
- `secure-store`: same-shaped API hardened for sensitive data, guaranteeing sensitive
  values never land in the non-secure store.
- `document-store`: typed collection store with injected codec, per-write/per-collection
  TTL, and registration-flag soft-delete with tombstones and explicit purge.
- `storage-failures`: the `Result<S, F>` type and sealed `StorageFailure` taxonomy with
  the never-raw-exception guarantee.
- `storage-configuration`: injected `VmStorageConfig`, key namespacing, selective backend
  registration through a single DI entry point, and the standalone visual `example/`.

### Modified Capabilities
<!-- None. This is a new module; no existing spec requirements change. -->

## Impact

- New package `packages/vm_storage`; added to root `workspace:` list in `pubspec.yaml`.
- New third-party dependencies: `shared_preferences`, `flutter_secure_storage`, `hive_ce`
  (+ `hive_ce_flutter`). Dev deps: `build_runner`, `freezed`, `json_serializable`,
  `injectable_generator`, `mocktail` for tests.
- Unit tests run against in-memory/fake implementations of each store interface; the real
  backends are exercised behind the same contracts.
- The `example/` depends on `vm_storyboard`; generic UI components missing from the design
  system may be added to `packages/vm_storyboard` as part of this change.
- Base (Propose 1) monorepo conventions consumed. No dependency on other `vm_*` modules.
  `Result`/`StorageFailure` defined locally now, earmarked for `vm_foundation` migration.
- `docs/` index updated to include the new module.
- **Out of scope**: remote synchronization, delta-sync, offline-first orchestration, and
  server-side databases (per the brief).
