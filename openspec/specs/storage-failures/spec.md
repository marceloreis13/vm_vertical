# storage-failures

## Purpose

Defines `vm_storage`'s typed error handling: the `Result<S, F>` wrapper, the
`StorageFailure` taxonomy, and the guarantee that no raw exceptions cross the module
boundary.

## Requirements

### Requirement: Typed Result wrapper

The module SHALL expose a `Result<S, F>` type representing either success or failure, used
as the return type of every store operation that can fail. The type SHALL be defined
locally in `lib/src/core/` and isolated so it can later migrate to `vm_foundation`.

#### Scenario: Success carries the value

- **WHEN** an operation succeeds
- **THEN** it returns a success `Result` exposing the produced value

#### Scenario: Failure carries a typed StorageFailure

- **WHEN** an operation fails
- **THEN** it returns a failure `Result` exposing a `StorageFailure`

### Requirement: StorageFailure taxonomy

The module SHALL define a sealed `StorageFailure` covering at least: not-found,
serialization, backend, security, and capability-unsupported. It SHALL be exhaustively
matchable via pattern matching.

#### Scenario: Not-found on missing key

- **WHEN** a read targets a key/record that does not exist (or is expired/soft-deleted)
- **THEN** the failure is the not-found variant

#### Scenario: Serialization failure on codec error

- **WHEN** encoding or decoding via an injected codec throws
- **THEN** the failure is the serialization variant

#### Scenario: Capability-unsupported for an unavailable operation

- **WHEN** a consumer invokes an operation a registered backend does not support
- **THEN** the failure is the capability-unsupported variant

### Requirement: No raw exceptions cross the boundary

Every public store operation SHALL translate backend errors into a `StorageFailure`
inside a `Result`. Raw exceptions from the underlying backend SHALL never propagate to
consumers.

#### Scenario: Backend throws internally

- **WHEN** the underlying backend throws during an operation
- **THEN** the store returns a failure `Result` with a `backend` `StorageFailure` and does
  not rethrow
