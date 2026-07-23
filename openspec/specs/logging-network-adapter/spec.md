## Purpose

Define the optional, opt-in adapter that logs HTTP request/response information through a `Logger` without introducing a dependency on `vm_network`.

## Requirements

### Requirement: Optional network-logging adapter without vm_network dependency

The module SHALL ship an optional adapter that logs HTTP request/response information through
a `Logger`. The adapter SHALL NOT import or depend on `vm_network`; it SHALL operate over
plain request/response data passed to it, so `vm_logging` remains free of any `vm_*`
dependency. An app SHALL wire the adapter only if it wants network logging.

#### Scenario: Adapter logs a request via the Logger

- **WHEN** the adapter is given request data (method, URL, status) and a `Logger`
- **THEN** it SHALL emit a structured entry describing the request without referencing any `vm_network` type

#### Scenario: Adapter is opt-in

- **WHEN** an app does not wire the adapter
- **THEN** `vm_logging` SHALL function fully and pull in no network dependency

### Requirement: Network adapter respects redaction

Entries produced by the network adapter SHALL pass through the same redaction pipeline as any
other entry, so sensitive headers or payload values (e.g. `authorization`) are masked.

#### Scenario: Sensitive header is masked in a request log

- **WHEN** the adapter logs a request whose headers include a configured sensitive key
- **THEN** the delivered entry SHALL show that header's value masked
