## Why

Modules and apps in the monorepo need consistent, structured diagnostics, but there is
no shared logging layer yet. Without one, every consumer prints ad-hoc `print`/`log`
calls bound to a destination, sensitive data leaks into logs, and there is no single
place to control levels or route to crash reporting. This change delivers `vm_logging`:
an injectable, level-based, structured logging abstraction where modules depend on a
`Logger` interface and the consuming app decides the levels, sinks, and redaction — with
no knowledge of the final destination inside the modules.

## What Changes

- New `packages/vm_logging` module following the standard scaffold (barrel
  `lib/vm_logging.dart`, `lib/src/`, `example/`, three test kinds, `resolution: workspace`).
- **`Logger` interface** — the single API consumers depend on: `trace/debug/info/warn/error`
  each taking a message plus an optional structured `fields` map and optional
  `error`/`stackTrace`. Calls are **synchronous and return `void`**: a logger never blocks
  and never throws at the call site. No vendor SDK type appears in the public API.
- **Structured context + scoped/child loggers** — a `Logger` carries a base context; a
  child logger created via a scope call binds fixed fields (e.g. `module`, `correlationId`)
  that are merged over the base context and into every entry it emits.
- **Pluggable sinks (`LogSink` port) with per-sink level threshold** — the logger fans out
  each entry that passes a sink's own `minLevel` to every registered sink (e.g. console at
  `debug`, crash bridge at `error`). A failure raised by one sink is **caught and isolated**
  so it neither affects the call site nor the other sinks (mirrors `vm_analytics`
  fire-and-forget isolation). Each sink handles any async internally.
- **Built-in `console`/`debug` and `noop` sinks** — `noop` for prod-silent/tests; the
  `console`/`debug` sink writes via `dart:developer` and exposes an **observable** record
  (buffer/stream) so the `example/` can render emitted logs on-screen at every level.
- **Redaction of sensitive data** — the app injects a set of **sensitive keys** (redacted
  by default wherever they appear in `fields`) plus registrable **pluggable redactors**
  (e.g. regex over field values and the message). Redaction runs before an entry reaches
  any sink, so sensitive data is never logged in clear.
- **Optional network-logging adapter** — a small helper to log HTTP requests/responses,
  shipped here with **no hard dependency on `vm_network`**; an app wires it if desired. The
  real interceptor inside `vm_network` is a future change.
- **Injected configuration** — `VmLoggingConfig` (the list of sinks with their per-sink
  `minLevel`, the sensitive keys, and the redactors) supplied by the consuming app through
  a single DI registration entry point (GetIt + Injectable). No app-specific value lives in
  the module.
- **Standalone `example/`** — a visual app (built with `vm_storyboard`) that emits logs at
  all levels, shows redaction in action, and renders them on-screen via the observable
  `debug` sink. Missing generic UI is promoted to `vm_storyboard`.
- Living docs: register `vm_logging` in `docs/` per project rule.

## Capabilities

### New Capabilities
- `logging-api`: the `Logger` interface (`trace/debug/info/warn/error` with message,
  structured `fields`, and optional `error`/`stackTrace`), its synchronous non-throwing
  contract, the five-level model, and scoped/child loggers that bind fixed context merged
  over a base context.
- `logging-sinks`: the pluggable `LogSink` port, per-sink `minLevel` filtering, fan-out to
  N sinks with per-sink error isolation, and the built-in `noop` and observable
  `console`/`debug` sinks (the latter exposing a buffer/stream for on-screen inspection).
- `logging-redaction`: injected sensitive keys redacted by default in `fields`, registrable
  pluggable redactors over field values and the message, and the guarantee that redaction
  runs before any sink so sensitive data is never emitted in clear.
- `logging-configuration`: the injected `VmLoggingConfig` (sinks + per-sink `minLevel` +
  sensitive keys + redactors), the single DI registration entry point, and the standalone
  visual `example/`.
- `logging-network-adapter`: the optional HTTP request/response logging adapter shipped
  with no hard dependency on `vm_network`, wired by the app only if desired.

### Modified Capabilities
<!-- None. This is a new module; no existing spec requirements change. -->

## Impact

- New package `packages/vm_logging`; added to the root `workspace:` list in `pubspec.yaml`.
- **No hard dependency on any `vm_*` module.** The optional network adapter does not import
  `vm_network`; `vm_logging` does not depend on `vm_analytics` (analytics is a future
  *consumer* of logging, re-homing its current `dart:developer` debug seam onto this module).
- Dev deps: `build_runner`, `injectable_generator`, `mocktail` (fake sinks/redactors for
  level, routing, and masking unit tests). `freezed`/`json_serializable` if value objects
  (log entry, level) warrant them.
- The `example/` depends on `vm_storyboard`; generic UI components missing from the design
  system may be added to `packages/vm_storyboard` as part of this change.
- `docs/` index updated to include the new module.
- Base (Propose 1) monorepo conventions consumed. Concrete crash-reporting providers
  (Crashlytics, Sentry, …) are **out of scope** — this change ships only the `LogSink` port
  plus `noop`/`console`. Server-side aggregation/observability is out of scope.
