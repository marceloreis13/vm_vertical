## 1. Scaffold & workspace

- [x] 1.1 Create `packages/vm_logging` via the standard module scaffold (barrel `lib/vm_logging.dart`, private `lib/src/`, `example/`, `test/`, `pubspec.yaml` with `resolution: workspace`)
- [x] 1.2 Add `packages/vm_logging` to the root `workspace:` list in `pubspec.yaml`
- [x] 1.3 Add dev deps (`build_runner`, `injectable_generator`, `mocktail`; `freezed`/`json_serializable` if used for `LogEntry`/`LogLevel`) and run initial `dart pub get`

## 2. Core domain: levels, entry, Logger

- [x] 2.1 Define `LogLevel` as five ordered levels `trace < debug < info < warn < error` with comparison support
- [x] 2.2 Define an immutable `LogEntry` (level, message, merged fields, timestamp, optional error/stackTrace)
- [x] 2.3 Define the `Logger` interface (`trace/debug/info/warn/error` with message, `fields`, and optional `error`/`stackTrace`), synchronous and returning `void`
- [x] 2.4 Implement the root `Logger` with base context and `forContext(...)` child loggers; merge precedence base < bound < per-call fields
- [x] 2.5 Guarantee non-throwing call contract (build entry → redact → fan-out, all wrapped)

## 3. Sinks

- [x] 3.1 Define the `LogSink` port receiving an already-redacted `LogEntry`
- [x] 3.2 Implement per-sink `minLevel` filtering and fan-out with per-sink `try/catch` error isolation (zero sinks = safe no-op)
- [x] 3.3 Implement built-in `noop` sink
- [x] 3.4 Implement built-in `console`/`debug` sink writing via `dart:developer` and exposing an observable buffer/stream
- [x] 3.5 Route isolated sink failures to a console fallback (never rethrow)

## 4. Redaction pipeline

- [x] 4.1 Define the `Redactor` abstraction (transform over field values and message)
- [x] 4.2 Implement key-based redaction over `fields` using injected sensitive keys (case-insensitive), preserving non-sensitive fields
- [x] 4.3 Apply registered redactors over field values and the message
- [x] 4.4 Wire redaction as a pipeline stage that runs on the `LogEntry` before any sink

## 5. Configuration & DI

- [x] 5.1 Define `VmLoggingConfig` (sinks with per-sink `minLevel`, sensitive keys, redactors)
- [x] 5.2 Implement the single `registerVmLogging(GetIt, VmLoggingConfig)` entry point (GetIt + Injectable) building and registering the root `Logger`
- [x] 5.3 Export only the public API from `lib/vm_logging.dart` (Logger, LogLevel, LogSink, Redactor, config, built-in sinks); keep everything else in `lib/src/`

## 6. Optional network-logging adapter

- [x] 6.1 Implement a network-logging adapter over plain request/response data (method, url, status, headers, duration) + a `Logger`, importing nothing from `vm_network`
- [x] 6.2 Ensure adapter entries flow through the redaction pipeline (sensitive headers masked)

## 7. Standalone example/

- [x] 7.1 Build `example/` with `vm_storyboard` emitting logs at every level and one with sensitive data
- [x] 7.2 Render emitted entries on-screen via the observable console sink, showing sensitive values masked
- [x] 7.3 Promote any missing generic UI component to `vm_storyboard`

## 8. Tests

- [x] 8.1 Unit: level ordering, threshold filtering per sink, and fan-out routing to fake sinks
- [x] 8.2 Unit: per-sink error isolation (one throwing sink does not block others or the call site) and zero-sink no-op
- [x] 8.3 Unit: child-logger context merge and precedence
- [x] 8.4 Unit: redaction — sensitive keys masked, non-sensitive preserved, redactors over values and message, network adapter headers masked
- [x] 8.5 Widget/golden: `example/` on-screen log rendering with masked values

## 9. Docs

- [x] 9.1 Add `docs/vm_logging.md` and register the module in `docs/index.md` per project rule
