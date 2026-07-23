## ADDED Requirements

### Requirement: Injected VmLoggingConfig

The module SHALL expose a `VmLoggingConfig` value supplied by the consuming app, carrying the
list of sinks with their per-sink `minLevel`, the set of sensitive keys, and the registered
redactors. No app-specific value (sink choice, levels, keys, redactors) SHALL be hard-coded
inside the module.

#### Scenario: App controls sinks and levels via config

- **WHEN** an app provides a `VmLoggingConfig` with a console sink at `debug` and a crash sink at `error`
- **THEN** the resolved `Logger` SHALL route entries to each sink according to its configured `minLevel`

### Requirement: Single DI registration entry point

The module SHALL expose exactly one DI registration function (GetIt + Injectable) that
receives the `VmLoggingConfig` and registers the `Logger`. Consumers SHALL depend only on the
`Logger` interface obtained from DI, without knowing the concrete sinks.

#### Scenario: Module resolves Logger from DI

- **WHEN** a module requests a `Logger` from the container after registration
- **THEN** it SHALL receive a working `Logger` and SHALL NOT reference any concrete sink type

### Requirement: Standalone visual example

The module SHALL ship a standalone `example/` app built with `vm_storyboard` that emits logs
at every level, demonstrates redaction, and renders emitted entries on-screen via the
observable console sink.

#### Scenario: Example renders emitted logs live

- **WHEN** the example emits logs at trace through error and one with sensitive data
- **THEN** the entries SHALL appear on-screen with sensitive values shown masked
