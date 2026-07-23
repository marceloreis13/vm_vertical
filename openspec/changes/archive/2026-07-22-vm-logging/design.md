## Context

The monorepo is a set of decoupled `vm_*` Lego modules consumed on demand by apps, with all
configuration injected by the app. `vm_analytics` already exists and deliberately left a
`dart:developer` "debug seam" earmarked for this module. `vm_logging` is a Tier-2 transversal
module (used by nearly everything) and, like `vm_analytics`, must be provider-agnostic: modules
depend on an interface, the app injects levels, destinations, and redaction. It must compile
standalone via `example/` and carry no hard `vm_*` dependency.

## Goals / Non-Goals

**Goals:**

- A single `Logger` interface with five levels, structured `fields`, and scoped child loggers.
- Synchronous, non-throwing call semantics — a logger is safe to call from anywhere.
- Pluggable `LogSink` port with per-sink `minLevel` and per-sink error isolation.
- Redaction (sensitive keys + pluggable redactors) applied before any sink sees an entry.
- Built-in `noop` and observable `console` sinks; optional network-logging adapter with no
  `vm_network` dependency.
- Injected `VmLoggingConfig` via one GetIt/Injectable registration entry point.

**Non-Goals:**

- Concrete crash-reporting sinks (Crashlytics/Sentry) — only the port ships here.
- Server-side aggregation/observability.
- A `vm_network` interceptor (future change in `vm_network`).
- Log persistence/rotation policy beyond what a sink chooses to implement.

## Decisions

**Synchronous `void` API, async isolated inside sinks.**
The `Logger` builds an immutable `LogEntry` (level, message, merged fields, timestamp,
optional error/stack), runs redaction, then loops sinks in a `try/catch` per sink. Slow or
async sinks buffer internally; a throwing sink is swallowed (and, at most, reported to a
console fallback) so the call site never blocks or sees an exception. Alternative — `Future<void>`
API — rejected: it pollutes call sites with `await`, invites forgotten awaits, and logging is
inherently fire-and-forget. This mirrors the `vm_analytics` fan-out/isolation model for
consistency.

**Per-sink `minLevel` instead of one global level.**
Each sink carries its own threshold; the fan-out checks `entry.level >= sink.minLevel` before
delivering. Realistic prod setups differ per destination (console verbose, crash only errors).
A single global level is just every sink sharing a threshold, so nothing is lost. Filtering
happens per sink (not once globally) so an `error` still reaches the crash sink while `debug`
still reaches console.

**Redaction as a pipeline stage before fan-out.**
Redaction runs once on the `LogEntry` before any sink, guaranteeing no destination can leak
clear data. Two mechanisms compose: (a) key-based — values under configured sensitive keys
(case-insensitive) are replaced with a placeholder; (b) pluggable redactors — ordered
transforms (typically regex) applied over field values and the message for patterns not tied
to a key (emails, card numbers, bearer tokens). Rejected alternative — a typed `Sensitive<T>`
wrapper requiring callers to mark data — rejected as the primary mechanism because it depends
on every call site remembering to wrap; key+redactor gives zero-friction default safety. (A
wrapper could be added later without breaking the pipeline.)

**Scoped/child loggers via context merge.**
`Logger.forContext({...})` returns a child holding merged bound fields over a base context.
Merge precedence at emit time: base context < bound child fields < per-call `fields`. Keeps
`module`/`correlationId` DRY without threading them through every call.

**Network adapter over plain data, not `vm_network`.**
The adapter accepts primitive request/response data (method, url, status, headers, duration)
plus a `Logger`, and emits a structured entry that flows through redaction like any other. It
imports nothing from `vm_network`, preserving zero `vm_*` coupling; a future `vm_network`
change provides the interceptor that calls this adapter.

**Config + DI shape.**
`VmLoggingConfig` = `{ sinks: List<SinkRegistration(sink, minLevel)>, sensitiveKeys: Set<String>,
redactors: List<Redactor> }`. One `registerVmLogging(GetIt, VmLoggingConfig)` builds the root
`Logger` and registers it; consumers resolve only the `Logger` interface.

## Risks / Trade-offs

- **Swallowed sink errors hide sink bugs** → the isolation catch reports to a console fallback
  so failures are visible in dev without breaking callers.
- **Redactor regexes can be costly on hot paths** → redaction only runs for entries that pass
  at least one sink's threshold; keep default redactors minimal and document the cost.
- **Key-based redaction misses sensitive data under unlisted keys / free-text** → mitigated by
  pluggable value/message redactors; documented that the sensitive-key set must be curated.
- **Synchronous fan-out could add latency if a sink does sync I/O** → contract requires sinks to
  offload async work internally; the built-in sinks comply and it is documented for custom sinks.
- **Duplicated debug seam with `vm_analytics`** → acceptable now; `vm_analytics` re-homes its
  seam onto `vm_logging` in a later change (out of scope here).

## Migration Plan

New additive module; no existing behavior changes. Add `packages/vm_logging` to the root
`workspace:` list, register the module in `docs/`, and ship `example/`. Rollback is removal of
the package and its workspace/docs entries. No consumer is required to adopt it in this change.
