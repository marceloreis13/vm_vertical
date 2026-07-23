## ADDED Requirements

### Requirement: Injectable auth-token interceptor

The client SHALL support an injectable async token provider. When present, an interceptor
SHALL attach the token to outgoing requests as an `Authorization` header (bearer scheme by
default, configurable). When no provider is configured, no auth header SHALL be added.

#### Scenario: Token attached when provider present

- **WHEN** a token provider returns a non-null token
- **THEN** the outgoing request SHALL include `Authorization: Bearer <token>`

#### Scenario: No auth header without provider

- **WHEN** no token provider is configured
- **THEN** the outgoing request SHALL NOT include an `Authorization` header

#### Scenario: Provider returns null

- **WHEN** the token provider returns null (e.g. logged-out state)
- **THEN** the request SHALL proceed without an `Authorization` header

### Requirement: Default headers

The client SHALL merge injected default headers (e.g. `Content-Type`, `Accept`, custom env
headers) into every request. Per-call header overrides SHALL take precedence over defaults.

#### Scenario: Default headers applied

- **WHEN** default headers are configured and a request is made without overriding them
- **THEN** the request SHALL include the configured default headers

#### Scenario: Per-call override wins

- **WHEN** a request supplies a header that is also a default
- **THEN** the per-call value SHALL be used instead of the default

### Requirement: Retry with backoff

The client SHALL retry idempotent-eligible failed requests according to an injected retry
policy (max attempts and backoff delay). Retries SHALL apply to transient failures (network,
timeout, and configured retriable server statuses) and SHALL NOT apply to client errors such
as 401/403/4xx-validation. When retries are exhausted, the last typed `Failure` SHALL be
returned.

#### Scenario: Transient failure is retried then succeeds

- **WHEN** a request first fails with a timeout and the retry policy allows another attempt
- **THEN** the client SHALL wait the backoff delay, retry, and return `Success` if the retry succeeds

#### Scenario: Retries exhausted returns failure

- **WHEN** all retry attempts fail
- **THEN** the client SHALL return the last typed `Failure`

#### Scenario: Non-retriable failure is not retried

- **WHEN** a request fails with an unauthorized (401) failure
- **THEN** the client SHALL NOT retry and SHALL return the unauthorized `Failure` immediately

### Requirement: Flag-controlled logging

The client SHALL log request/response details via `dart:developer` when the injected logging
flag is enabled, and SHALL log nothing when disabled. Logging SHALL avoid exposing secrets
(e.g. the `Authorization` header value SHALL be redacted). This logging seam SHALL be
structured so it can later delegate to `vm_logging` without changing the client.

#### Scenario: Logging on when flag enabled

- **WHEN** the logging flag is enabled and a request completes
- **THEN** request and response metadata SHALL be logged via `dart:developer`

#### Scenario: Silent when flag disabled

- **WHEN** the logging flag is disabled
- **THEN** the client SHALL emit no request/response logs

#### Scenario: Secrets redacted

- **WHEN** logging a request that carries an `Authorization` header
- **THEN** the logged output SHALL redact the token value

### Requirement: Consumer-supplied custom interceptors

The module SHALL let the consuming app register additional custom interceptors through the
config, expressed via a `vm_network` interceptor abstraction (not a Dio type). Custom
interceptors SHALL run in the chain after the built-in auth and default-headers interceptors
and before retry and logging, in the order supplied, so built-in auth and redaction
guarantees are preserved.

#### Scenario: Custom interceptor observes and mutates the request

- **WHEN** the app registers a custom interceptor that adds a header
- **THEN** outgoing requests SHALL include that header, without the app importing any Dio type

#### Scenario: Custom interceptors run in supplied order

- **WHEN** two custom interceptors are registered
- **THEN** they SHALL execute in the order provided, after auth/default-headers and before retry/logging

#### Scenario: No custom interceptors configured

- **WHEN** the config supplies no custom interceptors
- **THEN** only the built-in interceptors SHALL run, with unchanged behavior
