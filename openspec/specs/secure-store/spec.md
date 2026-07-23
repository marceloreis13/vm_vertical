# secure-store

## Purpose

Defines `vm_storage`'s secure persistence API for sensitive data (tokens, credentials),
its isolation from the non-secure key-value store, and the `flutter_secure_storage`
reference backend.

## Requirements

### Requirement: Secure persistence API for sensitive data

The module SHALL expose a `SecureStore` interface with a `set`/`get`/`remove`/
`containsKey`/`clear` shape for sensitive string values such as tokens and credentials.
The interface SHALL be a type distinct from `KeyValueStore` so that sensitive access sites
are explicit at the call point.

#### Scenario: Store and retrieve a token

- **WHEN** a consumer calls `set('access_token', value)` and later `get('access_token')`
- **THEN** the store returns `Result` success with the original value

#### Scenario: Read a missing secure key

- **WHEN** a consumer reads a secure key that was never written
- **THEN** the store returns a not-found `StorageFailure`, never a raw exception

### Requirement: Sensitive data isolation

Sensitive data written through `SecureStore` SHALL never be persisted by the non-secure
`KeyValueStore` backend. The two stores SHALL use separate, non-overlapping storage
namespaces so a secure value can never be read back through the key-value store.

#### Scenario: Secure value not visible to key-value store

- **WHEN** a value is written via `SecureStore.set('token', value)`
- **THEN** reading `'token'` through `KeyValueStore.get` returns a not-found failure

### Requirement: flutter_secure_storage reference backend

The module SHALL provide a `SecureStore` implementation backed by
`flutter_secure_storage`, registered only when the app opts into it, without leaking the
backend through the barrel.

#### Scenario: Optional registration

- **WHEN** an app registers the module without opting into the secure store
- **THEN** no `SecureStore` is registered and the app still builds and runs
