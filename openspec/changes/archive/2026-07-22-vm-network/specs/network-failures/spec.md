## ADDED Requirements

### Requirement: Result type

The module SHALL define a `Result<S, F>` type representing either a success value `S`
or a failure `F`, defined locally in `vm_network` (`lib/src/core/`) and isolated so it
can later migrate to `vm_foundation` without changing consumers' call sites. It SHALL
support exhaustive handling (pattern matching / `when`-style folding) of both cases.

#### Scenario: Success carries the value

- **WHEN** an operation succeeds with value `v`
- **THEN** the `Result` SHALL be a `Success` exposing `v` and match the success branch exhaustively

#### Scenario: Failure carries the typed error

- **WHEN** an operation fails
- **THEN** the `Result` SHALL be a `Failure` exposing a typed `Failure` value and match the failure branch exhaustively

### Requirement: Failure taxonomy

The module SHALL define a sealed `Failure` type whose variants cover at least: network
(no connectivity / connection error), timeout (connect/receive/send timeout), server
(non-2xx response, carrying status code and optional payload), parsing (deserialization
error), and unauthorized (HTTP 401/403). Each variant SHALL carry enough context to be
handled and logged (e.g. message, status code where applicable, underlying cause).

#### Scenario: Server response maps to server failure

- **WHEN** the server responds with a non-2xx status such as 500
- **THEN** the client SHALL produce a server `Failure` carrying the status code

#### Scenario: 401 maps to unauthorized failure

- **WHEN** the server responds with HTTP 401 or 403
- **THEN** the client SHALL produce an unauthorized `Failure` distinct from the generic server failure

#### Scenario: Connection timeout maps to timeout failure

- **WHEN** a request exceeds the configured connect or receive timeout
- **THEN** the client SHALL produce a timeout `Failure`

#### Scenario: No connectivity maps to network failure

- **WHEN** the request cannot reach the host (DNS/socket error)
- **THEN** the client SHALL produce a network `Failure`

### Requirement: No raw exceptions escape the client

Every failure path of the client SHALL be converted into a typed `Failure` inside a
`Result`. Unexpected/unclassified errors SHALL map to a defined fallback failure variant
rather than propagating as a raw exception to the caller.

#### Scenario: Unexpected error is classified, not thrown

- **WHEN** an error occurs that does not match a specific taxonomy case
- **THEN** the client SHALL return a `Failure` (fallback/unknown variant) and SHALL NOT throw
