# storage-configuration

## Purpose

Defines how `vm_storage` is configured and wired by consuming apps: the injected
`VmStorageConfig` object, the single DI registration entry point, key namespacing, and
the standalone visual example app.

## Requirements

### Requirement: Injected configuration

The module SHALL define a `VmStorageConfig` supplied by the consuming app, carrying the
key namespace/prefix, which backends to register, and per-collection options (TTL default
and soft-delete flag). The module SHALL NOT hard-code configuration or read global/ambient
state.

#### Scenario: Config provided at registration

- **WHEN** the app registers the module with a `VmStorageConfig`
- **THEN** the module wires its stores using only values from that config

### Requirement: Single DI registration entry point

The module SHALL expose one registration function in its barrel (GetIt + Injectable) that
receives `VmStorageConfig`. Registration SHALL be selective: the key-value, secure, and
document stores are each registered only when the app opts into them; secure and document
stores are optional.

#### Scenario: Register only the key-value store

- **WHEN** the app opts into only the key-value store
- **THEN** only `KeyValueStore` is resolvable from the container; resolving `SecureStore`
  or `DocumentStore` is unavailable

#### Scenario: Register all three stores

- **WHEN** the app opts into all stores
- **THEN** `KeyValueStore`, `SecureStore`, and each configured `DocumentStore` resolve from
  the container

### Requirement: Key namespacing

Keys SHALL be namespaced per app/module using the configured prefix so that two consumers
sharing a device cannot collide. The namespace SHALL be applied transparently by the store
so consumers use bare keys.

#### Scenario: Namespaced keys do not collide

- **WHEN** two modules with different namespaces both write key `'flag'`
- **THEN** each reads back only its own value

### Requirement: Standalone example

The module SHALL ship a runnable `example/` app built with `vm_storyboard` components that
demonstrates: CRUD of preferences via `KeyValueStore`, storing and reading a secure item
via `SecureStore`, and a `DocumentStore` collection showing TTL expiry and soft-delete.
Any missing generic UI component SHALL be promoted to `vm_storyboard`.

#### Scenario: Example demonstrates all three stores

- **WHEN** the example app is run
- **THEN** it exercises key-value CRUD, a secure item, and a document collection with TTL
  and soft-delete, using `vm_storyboard` components
