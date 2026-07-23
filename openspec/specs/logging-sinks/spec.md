## Purpose

Define the pluggable `LogSink` port, its per-sink level thresholds, fan-out with error isolation, and the built-in noop and console sinks.

## Requirements

### Requirement: Pluggable sink port

The module SHALL define a `LogSink` port that receives a fully-formed, already-redacted log
entry. Any number of concrete sinks SHALL be registrable without changing the `Logger` or
its call sites. Each sink SHALL be responsible for delivering the entry to its destination
and SHALL handle any asynchronous work internally.

#### Scenario: Adding a sink does not change call sites

- **WHEN** an app registers an additional sink
- **THEN** existing `Logger` call sites SHALL remain unchanged and the new sink SHALL start receiving entries

### Requirement: Per-sink minimum level threshold

Each registered sink SHALL have its own `minLevel` threshold. An entry SHALL be delivered to
a sink only when the entry's level is greater than or equal to that sink's `minLevel`. A
single global threshold SHALL be expressible by giving every sink the same `minLevel`.

#### Scenario: Entry below a sink threshold is not delivered to it

- **WHEN** a `debug` entry is produced and a sink has `minLevel = error`
- **THEN** that sink SHALL NOT receive the entry while a sink with `minLevel = debug` SHALL receive it

#### Scenario: Entry at or above threshold is delivered

- **WHEN** an `error` entry is produced and a sink has `minLevel = error`
- **THEN** that sink SHALL receive the entry

### Requirement: Fan-out with per-sink error isolation

The `Logger` SHALL fan out every entry that passes a sink's threshold to that sink. A failure
raised by one sink SHALL be caught and isolated so it neither propagates to the call site nor
prevents delivery to the other sinks. With zero registered sinks, logging SHALL be a safe
no-op.

#### Scenario: One failing sink does not block others

- **WHEN** an entry is delivered and one of several sinks throws
- **THEN** the remaining sinks SHALL still receive the entry and the call site SHALL NOT observe an exception

#### Scenario: No sinks registered is a safe no-op

- **WHEN** a logging call is made with no sinks registered
- **THEN** the call SHALL complete without error and do nothing

### Requirement: Built-in noop sink

The module SHALL ship a `noop` sink that accepts every entry and does nothing, for
prod-silent runs and tests.

#### Scenario: Noop discards all entries

- **WHEN** any entry reaches the `noop` sink
- **THEN** it SHALL complete successfully without side effects

### Requirement: Built-in observable console sink

The module SHALL ship a `console`/`debug` sink that writes entries via `dart:developer` and
exposes an observable record of received entries (buffer/stream) so a UI can display them
on-screen.

#### Scenario: Console sink writes developer log

- **WHEN** an entry reaches the `console` sink
- **THEN** it SHALL emit a developer-log line describing the entry's level, message, and fields

#### Scenario: Console sink exposes entries for inspection

- **WHEN** the example app subscribes to the `console` sink's observable record
- **THEN** it SHALL receive each entry in order for on-screen rendering
