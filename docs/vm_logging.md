# `vm_logging`

Injectable, level-based structured logging for the vm_core platform. Consumers
depend on a single `Logger` interface — the consuming app decides sinks,
levels and redaction. Every call is **synchronous and returns `void`**: a
logger never blocks and never throws at the call site, no matter what a sink
does. No vendor SDK type crosses the barrel, and the module carries **no
hard dependency on any other `vm_*` package**.

## Register at app startup

```dart
final consoleSink = ConsoleLogSink();

registerVmLogging(
  getIt,
  config: VmLoggingConfig(
    sinks: [
      SinkRegistration(sink: consoleSink, minLevel: LogLevel.debug),
      SinkRegistration(sink: myCrashReportingSink, minLevel: LogLevel.error),
    ],
    sensitiveKeys: {'password', 'authorization', 'token'},
    redactors: [RegexRedactor(RegExp(r'[\w.+-]+@[\w-]+\.[\w.-]+'))], // emails
  ),
);
```

Nothing is hard-coded inside the module — sinks, per-sink `minLevel`,
sensitive keys and redactors always come from the consuming app. An empty
`VmLoggingConfig()` (no sinks) makes logging a safe no-op.

## Use the logger

```dart
final logger = getIt<Logger>();

logger.info('user signed in', fields: {'userId': user.id});
logger.warn('slow response', fields: {'ms': 1200});
logger.error('save failed', error: e, stackTrace: st, fields: {'userId': user.id});

// Scoped/child logger: binds fixed fields onto every entry it emits.
final authLogger = logger.forContext({'module': 'auth'});
authLogger.info('login attempt'); // carries module: auth
```

Merge precedence at emit time: base context < bound child fields < per-call
`fields` — the most specific value wins on key collision.

## Levels

Five ordered levels: `trace < debug < info < warn < error`. Each sink has its
own `minLevel` threshold (`SinkRegistration`); an entry reaches a sink only
when `entry.level >= sink.minLevel`. A single global level is just every sink
sharing the same threshold.

## Sinks

`LogSink` is the pluggable destination port — implement `handle(LogEntry)` to
add a new one (e.g. a crash-reporting bridge); no change to call sites or the
`Logger` is needed. A failure raised by one sink is caught and isolated: it
never reaches the call site and never blocks delivery to the other sinks.

Built in:

- **`NoopLogSink`** — discards everything; for prod-silent runs and tests.
- **`ConsoleLogSink`** — writes via `dart:developer` and exposes an
  **observable** record of received entries (`buffer`, `entries` stream) so a
  UI can render emitted logs live — see the visual example below.

## Redaction

Runs once on every `LogEntry`, before any sink sees it:

1. **Sensitive keys** — any `fields` entry whose key matches a configured
   sensitive key (case-insensitive) has its value replaced by
   `kRedactionPlaceholder` wholesale.
2. **Pluggable redactors** (`Redactor`) — ordered transforms (typically
   `RegexRedactor`) applied over every remaining field value and the message,
   for patterns not tied to a specific key (emails, card numbers, bearer
   tokens).

## Optional network-logging adapter

`NetworkLogAdapter` logs one HTTP exchange through a `Logger`, given plain
data only (method, url, status, headers, duration) — it imports nothing from
`vm_network`, so `vm_logging` stays free of any `vm_*` dependency. An app (or
a future `vm_network` interceptor) wires it only if it wants network logging:

```dart
final adapter = NetworkLogAdapter(logger);
adapter.logExchange(
  method: 'POST',
  url: 'https://api.example.com/login',
  statusCode: response.statusCode,
  headers: response.headers,
  duration: stopwatch.elapsed,
);
```

Entries it produces flow through the same redaction pipeline as any other
call — a sensitive header (e.g. `authorization`) configured as a sensitive
key is masked before delivery.

## Visual example

`packages/vm_logging/example/` is a standalone Flutter app demonstrating logs
at every level, a call with sensitive data, and one via `NetworkLogAdapter`,
rendering each entry live via `ConsoleLogSink`'s observable stream with
sensitive values shown masked. The demo screen (`LoggingDemoScreen`) lives in
`lib/` and is exported by the barrel, so any app can embed it directly via
`package:vm_logging/vm_logging.dart` — the `example/` app is only a thin
shell that registers the module and runs it.

## Out of scope

Concrete crash-reporting sinks (Crashlytics, Sentry, ...) and server-side log
aggregation/observability are not part of this module — only the `LogSink`
port plus `noop`/`console` ship here. A real `vm_network` interceptor that
calls `NetworkLogAdapter` is a future change.
