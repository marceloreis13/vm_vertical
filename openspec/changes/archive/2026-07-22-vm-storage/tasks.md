## 1. Scaffold

- [x] 1.1 Create `packages/vm_storage` per module-scaffold (barrel `lib/vm_storage.dart`, `lib/src/`, `example/`, `test/`, `resolution: workspace`)
- [x] 1.2 Add package to root `workspace:` list in `pubspec.yaml`
- [x] 1.3 Add deps (`shared_preferences`, `flutter_secure_storage`, `hive_ce`, `hive_ce_flutter`) and dev deps (`build_runner`, `freezed`, `json_serializable`, `injectable_generator`, `mocktail`); include shared `analysis_options.yaml`

## 2. Core — Result & Failures

- [x] 2.1 Define `Result<S, F>` in `lib/src/core/` (isolated for future `vm_foundation`)
- [x] 2.2 Define sealed `StorageFailure` (not-found, serialization, backend, security, capability-unsupported) with Freezed and exhaustive matching
- [x] 2.3 Add a helper that wraps backend calls and maps thrown errors to `StorageFailure` (no raw exception crosses the boundary)
- [x] 2.4 Unit tests: success/failure carry values; error-wrapping maps to correct variants

## 3. Configuration & DI

- [x] 3.1 Define `VmStorageConfig` (key namespace/prefix, backend opt-ins, per-collection TTL default + soft-delete flag)
- [x] 3.2 Implement transparent key namespacing applied by the stores
- [x] 3.3 Implement single `registerVmStorageModule(GetIt, {required VmStorageConfig})` entry point in the barrel (GetIt + Injectable), registering only opted-in stores
- [x] 3.4 Unit tests: selective registration (KV only vs all three), namespacing isolation between two prefixes

## 4. Key-Value Store

- [x] 4.1 Define `KeyValueStore` interface (`set`/`get`/`remove`/`containsKey`/`clear`; string/bool/int/double/string-list)
- [x] 4.2 Implement `shared_preferences` backend (behind the barrel)
- [x] 4.3 Implement in-memory fake for tests
- [x] 4.4 Unit tests: write/read, missing-key not-found, physical remove, backend-swap contract

## 5. Secure Store

- [x] 5.1 Define `SecureStore` interface (distinct type; `set`/`get`/`remove`/`containsKey`/`clear`)
- [x] 5.2 Implement `flutter_secure_storage` backend with a separate namespace from KV
- [x] 5.3 Implement in-memory fake for tests
- [x] 5.4 Unit tests: store/read token, missing-key not-found, sensitive value not readable via `KeyValueStore`, optional registration

## 6. Document Store

- [x] 6.1 Define `DocumentStore<T>` interface with injected codec + `keyOf` (`put`/`get`/`getAll`/`delete`/`clear`/`purge`)
- [x] 6.2 Implement Hive CE backend (behind the barrel) storing record + expiry + optional tombstone metadata
- [x] 6.3 Implement TTL (per-put and per-collection default) with lazy eviction on read
- [x] 6.4 Implement registration-flag soft-delete (tombstone with `deletedAt`, reads exclude, `purge` hard-deletes; physical delete when disabled)
- [x] 6.5 Implement in-memory fake honoring TTL + soft-delete semantics
- [x] 6.6 Unit tests: put/get roundtrip via codec, getAll, codec-error → serialization failure, TTL expiry, soft-delete hide/purge, physical delete when disabled

## 7. Example App

- [x] 7.1 Build `example/` with `vm_storyboard`: preferences CRUD (KV), secure item (Secure), document collection with TTL + soft-delete demo
- [x] 7.2 Wire the single registration entry point with a sample `VmStorageConfig`
- [x] 7.3 Promote any missing generic UI component to `vm_storyboard` (none needed — demo is built entirely from existing components)
- [x] 7.4 Confirm the example runs and exercises all three stores (built, launched, and screenshotted on iOS simulator)

## 8. Docs & Verification

- [x] 8.1 Add `docs/vm_storage.md` and update `docs/index.md` per project rule
- [x] 8.2 Run `dart analyze` (barrel/implementation-imports clean) and `dart format`
- [x] 8.3 Run `build_runner` and the full test suite; ensure green
