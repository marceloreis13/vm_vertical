## Context

The monorepo needs a shared local-persistence layer. The brief (`briefs/4-vm-storage.md`)
asks for three stores — light key-value, secure, and structured/cache — behind a stable,
injectable API so the concrete backend can be swapped without touching consumers. It
depends only on the base monorepo conventions (Propose 1), no other `vm_*` module.

`vm_network` sets the precedent this module follows: a locally-defined `Result` + sealed
failure taxonomy earmarked for a future `vm_foundation`, an injected config with a single
DI registration entry point, no consumer models leaking into the module, backends hidden
behind the barrel, and a visual `example/` built from `vm_storyboard`.

Two clarifications from the brief were resolved before design: the offline-first / delta
-sync paragraph is treated as **out of scope** (only a registration-time soft-delete flag
survives from it), and the "single `Storage` interface" wording is realized as **three
typed interfaces** rather than one God-interface.

## Goals / Non-Goals

**Goals:**
- Three typed store contracts (`KeyValueStore`, `SecureStore`, `DocumentStore<T>`), each
  with distinct semantics, resolvable via a single injected registration function.
- Reference backends: `shared_preferences`, `flutter_secure_storage`, Hive CE — none
  leaking through the barrel.
- Typed `Result` + sealed `StorageFailure`; no raw exceptions cross the boundary.
- `DocumentStore` TTL and optional (registration-flag) soft-delete with tombstones + purge.
- Selective, namespaced registration; secure/document stores optional per app.
- Runnable `vm_storyboard`-based `example/`; unit tests against in-memory fakes.

**Non-Goals:**
- Remote synchronization, delta-sync, offline-first orchestration, server databases.
- Reactive/stream reads (`watch`) — reads are point-in-time in this change.
- Cross-store transactions or a unified query language across backends.

## Decisions

- **Three interfaces over one `Storage`.** KV, secure, and document have materially
  different shapes (secure sensitivity; document codec/TTL/soft-delete/queries). Distinct
  types keep sensitive access sites explicit and avoid capability flags on a God-interface.
  *Alternative:* single `Storage` with capability probing — rejected as leaky and untyped.

- **Hive CE for the document backend.** Pure-Dart, no codegen conflict with the module's
  Freezed/Injectable pipeline, trivial to run in `example/`. *Alternatives:* Isar (powerful
  but unstable maintenance, own codegen) and Drift (robust SQL but heavier setup) — both
  rejected as the default reference; the interface keeps them pluggable later.

- **Injected codec + `keyOf` on `DocumentStore<T>`.** Mirrors `vm_network`'s decoder seam:
  serialization is the consumer's Freezed/Json `toJson`/`fromJson`, passed in; the module
  never imports a consumer model. Keeps the boundary generic and swap-friendly.

- **TTL and soft-delete on `DocumentStore` only.** KV/secure keep simple physical delete.
  TTL is stored as an expiry timestamp alongside each record and evicted lazily on read.
  Soft-delete writes a `deletedAt` tombstone; normal reads filter it; `purge` hard-deletes.
  The soft-delete flag is set at registration (per collection), not per call.

- **Local `Result`/`StorageFailure` in `lib/src/core/`.** Same isolation strategy as
  `vm_network` so a later `vm_foundation` can absorb both without a consumer-visible change.

- **Selective, namespaced registration.** `VmStorageConfig` declares which backends to
  register plus a key prefix applied transparently. Secure/document are optional so a
  minimal app pulls in no secure-storage/Hive weight it does not use.

## Risks / Trade-offs

- **Hive CE longevity** → interface isolation means a backend swap (to Drift/Isar/Firestore
  -backed) is contained to one implementation class; consumers are unaffected.
- **Lazy TTL eviction leaves expired bytes until next access** → acceptable for a local
  cache; `purge`/`clear` and read-time eviction bound growth; a future sweep can be added.
- **Injected codec pushes serialization correctness to the consumer** → documented in the
  contract; codec errors surface as typed serialization failures, never crashes.
- **Soft-delete flag is registration-time, not per-call** → simpler, predictable per
  collection; matches the brief's "set ao registrar o módulo". Revisitable if a consumer
  needs mixed behavior.
- **flutter_secure_storage platform variance** (keychain/keystore quirks) → kept behind the
  `SecureStore` contract; tests run against an in-memory fake, real backend smoke-tested in
  the example.
