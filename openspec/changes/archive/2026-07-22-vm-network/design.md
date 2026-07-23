## Context

`vm_core` is a modular Flutter monorepo ("Lego board"): apps compose reusable `vm_*`
packages on demand. Base (Propose 1) established the conventions — Clean Architecture +
feature-first, barrel-only public API, DI via GetIt + Injectable with config injected by the
consuming app, and a standalone runnable `example/` per module. Today only `vm_storyboard`
exists.

`vm_network` is an infrastructure module: a generic HTTP client with typed results and a
standardized failure taxonomy, so no consumer reimplements request handling or leaks the
transport library. The architecture memory earmarks `Result`/`Failure`/`VMModule` for a
future `vm_foundation` package, but that package does not exist yet, so this change defines
those primitives locally and keeps them isolated for later migration.

Constraints: barrel-only public surface; config never hard-coded; Dio hidden behind the
abstraction; failures always typed, never raw exceptions.

## Goals / Non-Goals

**Goals:**
- A reusable, injectable HTTP client consumed by 2+ modules/apps without changing the core.
- Every error path returns a typed `Failure` inside a `Result` — no raw exceptions escape.
- Typed deserialization at the boundary that stays decoupled from consumer domain models.
- Interceptors for auth, default headers, retry/backoff, and flag-controlled logging, plus a
  seam for consumer-supplied custom interceptors.
- A visual standalone `example/` built with `vm_storyboard`, covering direct, basic-auth, and
  bearer-token connections, explicit error scenarios, and interceptors in action.

**Non-Goals:**
- Domain-data caching or local persistence (belongs to `vm_storage`).
- Creating `vm_foundation` (a later change); `Result`/`Failure` live locally for now.
- A full `vm_logging` integration (Propose 8); logging uses `dart:developer` via a seam.
- App-specific endpoints, DTOs, or presentation beyond what the example needs.

## Decisions

### Dio as the internal transport, hidden behind an abstraction
Dio provides interceptors, retry hooks, timeouts, and cancellation out of the box, matching
the brief directly. The public API exposes an abstract `VmHttpClient` (REST methods returning
`Result<T, Failure>`); the Dio-backed implementation lives in `lib/src/` and never appears in
a public signature. *Alternative:* `package:http` — rejected because interceptors/retry would
be hand-built, duplicating what Dio already offers.

### `Result<S, F>` + sealed `Failure` defined locally, isolated in `lib/src/core/`
Placed under a dedicated `core/` slice so the eventual move to `vm_foundation` is a re-home,
not a rewrite. `Result` is a sealed/Freezed union with exhaustive folding; `Failure` is a
sealed union: `NetworkFailure`, `TimeoutFailure`, `ServerFailure(statusCode, payload?)`,
`ParsingFailure`, `UnauthorizedFailure`, plus an `UnknownFailure` fallback. *Alternative:*
depend on a not-yet-existent `vm_foundation` (blocks this change) or pull `dartz`/`fpdart`
(extra dependency, less tailored) — both rejected.

### Typed decode at the client boundary via injected per-call decoder
Methods take `T Function(Object? json)` and return `Result<T, Failure>`; the consumer's
generated `fromJson` plugs in as the decoder. The decoder call is wrapped in try/catch →
`ParsingFailure`, so the "never raw exceptions" guarantee holds end to end and the taxonomy's
parsing case has a real origin. Decoupling is preserved because the decoder is injected per
call — `vm_network` imports no consumer model. A raw variant returns `Result<JsonMap,
Failure>` for schema-less responses. *Alternative:* return raw JSON and let consumers parse —
rejected because parsing failures would then live outside the client's typed guarantee.

### Error mapping centralized in one interceptor/translator
A single translation layer converts `DioException`/status codes into the `Failure` taxonomy,
so classification is consistent and unit-testable in isolation (with `http_mock_adapter`).

### Retry/backoff as a policy-driven interceptor
An injected `RetryPolicy` (max attempts, backoff) drives retries only for transient failures
(network, timeout, configured retriable statuses); 401/403 and validation errors are never
retried. Keeps behavior configurable per app.

### Pluggable custom interceptors via config
`VmNetworkConfig` accepts an optional ordered list of additional interceptors that the
consuming app registers, so app-specific request/response behavior (e.g. correlation-id
headers, tenant routing, metrics) plugs in without modifying the module. The module's
built-in interceptors run in a defined order and custom interceptors are appended after
them (auth → default headers → custom → retry → logging), keeping auth/redaction guarantees
intact. To avoid leaking Dio, custom interceptors are expressed through a thin `vm_network`
interceptor abstraction that the module adapts to Dio internally. *Alternative:* expose Dio's
`Interceptor` directly — rejected because it would leak the transport across the barrel.

### Example built with `vm_storyboard`, covering errors and interceptors
The `example/` composes its screens and sections from `vm_storyboard` components (Screen /
Sections / Views per the UI-composition convention), not ad-hoc widgets. Besides the success
connection styles, it drives explicit error scenarios — 404/500 (server), 401 (unauthorized),
and timeout — and makes the interceptors observable (auth token attached, retry happening, a
custom interceptor's effect). If a generic component is missing from the design system, it is
promoted to `vm_storyboard` rather than built locally. *Alternative:* build example UI locally
— rejected because it would duplicate patterns the design system should own.

### Logging via a thin seam over `dart:developer`
A small internal logger interface writes via `dart:developer` when the config flag is on, and
redacts `Authorization`. Because it is an interface, `vm_logging` can later back it without
touching the client. *Alternative:* call `dart:developer` inline — rejected for making the
future `vm_logging` swap invasive.

### DI: single registration function receiving `VmNetworkConfig`
Per conventions, the barrel exposes one registration entry point; the app passes its config.
Given the small internal graph, a plain imperative `registerSingleton`-style function is
acceptable (per module-scaffold practical notes) even if Injectable codegen is scaffolded.

### Example uses real public APIs
Direct: a no-auth public JSON API. Basic auth: `httpbin.org/basic-auth/...`. Bearer:
`httpbin.org/bearer`. Error subset: `httpbin.org/status/404` and `/status/500` (server),
unauthorized via a failing `/basic-auth` or `/bearer` call (401), and timeout via
`httpbin.org/delay/<n>` against a short receive timeout. Retry is shown on top of the 500
scenario. Public endpoints keep the example self-contained and tweakable.

## Risks / Trade-offs

- **Local `Result`/`Failure` may diverge from the future `vm_foundation` version** →
  Isolate in `lib/src/core/` with minimal surface and document the migration intent so the
  later move is mechanical; consumers use only the barrel-exported types.
- **Public API accidentally leaks Dio types** → Enforce via an abstract client, a barrel that
  exports only `vm_network` types, and a review/lint check; no Dio type in any signature.
- **Example depends on third-party public APIs (flakiness/rate limits)** → Prefer stable
  endpoints (`httpbin`), keep inputs easy to swap, and show typed-failure states gracefully
  so an outage still demonstrates the error path rather than crashing.
- **Retry masking non-idempotent side effects** → Default retries to transient/idempotent
  cases and 5xx allow-list only; leave non-idempotent retry opt-in via policy.
- **Logging leaking secrets** → Redact `Authorization` and known sensitive headers at the
  logging seam; covered by a unit test.
- **Custom interceptors leaking Dio or breaking guarantees** → Expose custom interceptors
  through a `vm_network` interceptor abstraction (not Dio's type) and append them in a fixed
  slot in the chain so built-in auth/retry/redaction ordering is preserved; cover ordering
  with a unit test.
- **Promoting components to `vm_storyboard` widens this change's blast radius** → Promote only
  genuinely generic pieces, keep each addition small and golden-tested, and leave anything
  example-specific local to `vm_network/example/`.

## Migration Plan

New additive module; no rollback concerns for existing code. Steps: scaffold
`packages/vm_network`, add to root `workspace:`, implement core/data/interceptors, wire DI,
build the example, add tests, update `docs/`. Rollback = remove the package and its workspace
entry. Future `vm_foundation` change will re-home `Result`/`Failure`.

## Open Questions

- None blocking. Exact retriable status allow-list and default timeout values will be set as
  sensible defaults in `VmNetworkConfig` and can be tuned by consumers.
