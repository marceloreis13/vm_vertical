# http-client

## Purpose

Defines the public REST client surface of `vm_network`: typed generic REST methods
(`get`/`post`/`put`/`patch`/`delete`), decoding at the client boundary via consumer
`fromJson`, a raw-JSON escape hatch for schema-less responses, and the guarantee that
no underlying HTTP library type (e.g. Dio) leaks across the public barrel.

## Requirements

### Requirement: Generic REST request methods

The client SHALL expose REST methods `get`, `post`, `put`, `patch`, and `delete`,
each accepting a relative path, and optionally query parameters, a request body,
and per-call header overrides. Each method SHALL resolve the path against the
injected `baseUrl` and return a `Result<T, Failure>` — never throwing on transport
or protocol errors.

#### Scenario: Successful GET returns decoded value

- **WHEN** a `get` call to a reachable endpoint returns HTTP 200 with a JSON body
- **THEN** the client SHALL return `Success` wrapping the decoded value `T`

#### Scenario: POST sends body and returns decoded value

- **WHEN** a `post` call is made with a JSON-serializable body and the server responds 201
- **THEN** the client SHALL serialize the body, send it, and return `Success` with the decoded response

#### Scenario: Relative path resolved against baseUrl

- **WHEN** a request is made with a relative path such as `users/1`
- **THEN** the client SHALL resolve it against the injected `baseUrl` to form the final URL

### Requirement: Typed deserialization at the client boundary

Request methods SHALL accept a per-call decoder `T Function(Object? json)` and return
`Result<T, Failure>`. The consumer's `fromJson` (Freezed / JsonSerializable) SHALL be
usable directly as the decoder. Invoking the decoder SHALL be wrapped so that any
exception it throws is converted into a parsing failure rather than propagating.

#### Scenario: Consumer fromJson used as decoder

- **WHEN** a request passes a model's `fromJson` as the decoder and the response body matches
- **THEN** the client SHALL return `Success` with the fully constructed model instance

#### Scenario: Decoder throws on malformed body

- **WHEN** the response body cannot be decoded by the provided decoder (e.g. missing field, wrong type)
- **THEN** the client SHALL catch the error and return a `Failure` of the parsing kind, never rethrowing

### Requirement: Raw-JSON escape hatch

The client SHALL provide a raw variant that returns `Result<JsonMap, Failure>` (or a
list equivalent) without requiring a typed decoder, for dynamic or schema-less responses.

#### Scenario: Raw request returns undecoded map

- **WHEN** a raw request succeeds with a JSON object body
- **THEN** the client SHALL return `Success` wrapping the parsed `Map<String, dynamic>` without applying a model decoder

### Requirement: Underlying HTTP library is not leaked

The public API SHALL NOT expose Dio types (e.g. `Response`, `DioException`, `Options`)
across the barrel. Consumers SHALL depend only on `vm_network` public types.

#### Scenario: Public API free of Dio types

- **WHEN** a consumer imports `package:vm_network/vm_network.dart`
- **THEN** no method signature, return type, or exported symbol SHALL reference a Dio type
