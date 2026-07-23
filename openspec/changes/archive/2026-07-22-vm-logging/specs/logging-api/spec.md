## ADDED Requirements

### Requirement: Level-based Logger interface

The module SHALL define a `Logger` interface exposing one method per level —
`trace`, `debug`, `info`, `warn`, `error` — each taking a message and an optional
structured `fields` map, with the `error`/`warn` calls additionally accepting an optional
`error` object and `stackTrace`. This interface SHALL be the single API consumers depend
on, and no vendor SDK type SHALL appear in it.

#### Scenario: Emit at each level

- **WHEN** a consumer calls `logger.info('started', fields: {'id': 7})`
- **THEN** an `info` entry carrying the message and fields SHALL be produced for routing

#### Scenario: Error entry carries error and stack trace

- **WHEN** a consumer calls `logger.error('failed', error: e, stackTrace: st)`
- **THEN** the produced entry SHALL carry the level `error`, the message, the `error`, and the `stackTrace`

### Requirement: Synchronous non-throwing call contract

Every `Logger` call SHALL be synchronous and return `void`. A logging call SHALL NOT block
the caller and SHALL NOT throw at the call site, regardless of sink behavior or failures.
Any asynchronous work SHALL be performed inside sinks.

#### Scenario: Call site never throws

- **WHEN** a logging call is made and a downstream sink would fail or is slow
- **THEN** the `Logger` call SHALL return normally without throwing or awaiting

### Requirement: Five ordered severity levels

The module SHALL define exactly five ordered levels `trace < debug < info < warn < error`.
The ordering SHALL be usable to compare an entry's level against a threshold.

#### Scenario: Level ordering is total and comparable

- **WHEN** an entry's level is compared against a threshold level
- **THEN** the comparison SHALL reflect `trace < debug < info < warn < error`

### Requirement: Scoped child loggers with bound context

A `Logger` SHALL carry a base context and SHALL be able to create a child logger that binds
additional fixed fields (e.g. `module`, `correlationId`). A child logger SHALL merge its
bound fields over the base context, and per-call `fields` SHALL merge over both, with the
most specific value winning on key collision.

#### Scenario: Child logger injects bound fields

- **WHEN** a child logger bound with `{'module': 'auth'}` emits `info('login', fields: {'id': 7})`
- **THEN** the produced entry SHALL carry both `module: auth` and `id: 7`

#### Scenario: Per-call field overrides bound field

- **WHEN** a child logger bound with `{'module': 'auth'}` emits with `fields: {'module': 'billing'}`
- **THEN** the entry's `module` SHALL be `billing`
