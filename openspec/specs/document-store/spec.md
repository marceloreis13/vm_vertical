# document-store

## Purpose

Defines `vm_storage`'s typed document collection API: the `DocumentStore<T>` interface
for persisting typed records, TTL expiry, optional soft-delete with tombstones, and the
Hive CE reference backend.

## Requirements

### Requirement: Typed document collection API

The module SHALL expose a `DocumentStore<T>` interface for persisting typed records in a
named collection. Each store instance SHALL be configured with an injected codec
(`Map<String, dynamic> Function(T)` and `T Function(Map<String, dynamic>)`) and a
`keyOf` function that derives a record's key. The API SHALL provide `put`, `get`,
`getAll`, `delete`, and `clear`. Reads SHALL be point-in-time (Future-based); the store
SHALL NOT expose stream/reactive reads in this change.

#### Scenario: Put then get a typed record

- **WHEN** a consumer calls `put(item)` and later `get(keyOf(item))`
- **THEN** the store returns `Result` success with an equal `T` reconstructed via the codec

#### Scenario: Get all records

- **WHEN** several records are written to a collection and `getAll()` is called
- **THEN** the store returns success with all live records

#### Scenario: Codec failure becomes a typed failure

- **WHEN** stored bytes cannot be decoded by the injected codec
- **THEN** the store returns a serialization `StorageFailure`, never a raw exception

#### Scenario: Consumer models do not leak into the module

- **WHEN** the module is compiled
- **THEN** no consumer Freezed/Json model type is referenced by the module; typing flows
  only through the injected codec and `T`

### Requirement: Time-to-live (TTL) expiry

`DocumentStore` SHALL support TTL, set per `put` call and/or as a per-collection default
from configuration. An entry whose TTL has elapsed SHALL read as absent (not-found) and
SHALL be evicted lazily on access. TTL SHALL apply only to `DocumentStore`, never to the
key-value or secure stores.

#### Scenario: Expired entry reads as absent

- **WHEN** a record is written with a TTL that has since elapsed and is then read
- **THEN** the store returns a not-found failure and the entry is removed

#### Scenario: Live entry within TTL is returned

- **WHEN** a record is read before its TTL elapses
- **THEN** the store returns success with the record

### Requirement: Optional soft-delete with tombstones

`DocumentStore` SHALL support soft-delete, enabled by a flag supplied at module
registration (per collection). When enabled, `delete` SHALL write a tombstone recording a
`deletedAt` timestamp and normal reads (`get`/`getAll`) SHALL exclude soft-deleted
records. An explicit purge operation SHALL physically remove tombstoned records. When the
flag is disabled, `delete` SHALL physically remove the record immediately.

#### Scenario: Soft-deleted record hidden from reads

- **WHEN** soft-delete is enabled and a record is deleted
- **THEN** `get` and `getAll` no longer return it, while the tombstone is retained

#### Scenario: Purge removes tombstones

- **WHEN** purge is called on a collection with tombstoned records
- **THEN** those records are physically removed

#### Scenario: Physical delete when soft-delete disabled

- **WHEN** soft-delete is disabled and a record is deleted
- **THEN** the record is physically removed with no tombstone

### Requirement: Hive CE reference backend

The module SHALL provide a `DocumentStore` implementation backed by Hive CE, registered
only when the app opts into it, without leaking Hive types through the barrel.

#### Scenario: Backend swap is invisible to consumers

- **WHEN** the Hive-backed implementation is replaced by another honoring the
  `DocumentStore<T>` contract (including TTL and soft-delete semantics)
- **THEN** consuming code compiles and behaves unchanged
