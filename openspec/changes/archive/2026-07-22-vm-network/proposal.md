## Why

Apps and modules in the monorepo need to consume HTTP APIs, but there is no shared
networking layer yet. Without one, every consumer would reinvent request handling,
leak the underlying HTTP library, and surface raw exceptions instead of typed
failures. This change delivers `vm_network`: a generic, injectable HTTP client that
returns typed results and standardized failures, reusable by any app or module.

## What Changes

- New `packages/vm_network` module following the standard scaffold (barrel, `lib/src/`,
  `example/`, three test kinds, `resolution: workspace`).
- Generic **HTTP client** exposing REST methods (GET/POST/PUT/PATCH/DELETE), built on
  **Dio** internally. Dio never leaks through the barrel.
- **Typed result + failure taxonomy** defined locally in `vm_network` (`lib/src/core/`),
  isolated for a future migration to `vm_foundation`: a `Result<S, F>` type and a sealed
  `Failure` covering network, timeout, server, parsing, and unauthorized cases. Network
  errors always arrive as typed failures, never raw exceptions.
- **Typed deserialization at the client boundary**: request methods accept a per-call
  decoder (`T Function(Object? json)`) and return `Result<T, Failure>`; decoder errors
  become a parsing failure inside the client. A raw variant returns `Result<JsonMap,
  Failure>` for dynamic responses. The client depends on no consumer model.
- **Interceptors**: injectable auth-token provider, default headers, retry/backoff, and
  request/response logging via `dart:developer` (flag-controlled), to be re-homed onto
  `vm_logging` when it exists. Consumers MAY also register **additional custom
  interceptors** through the config, so app-specific request/response behavior is pluggable
  without changing the module.
- **Injected configuration**: `VmNetworkConfig` (baseUrl, default headers, token provider,
  timeouts, retry policy, logging flag, optional custom interceptors) supplied by the
  consuming app via a single DI
  registration entry point. No app-specific endpoint lives in the module.
- **Standalone `example/`**: a visual app whose screens and sections are built with
  `vm_storyboard` components, demonstrating direct public-API access, credentialed (basic
  auth) access, and bearer-token access; explicit **error scenarios** (404/500 server, 401
  unauthorized, timeout); and the **interceptors in action** (auth token attached, retry
  happening, custom interceptor). Any missing generic UI component is **promoted to
  `vm_storyboard`**.
- Living docs: register `vm_network` in `docs/` per project rule.

## Capabilities

### New Capabilities
- `http-client`: generic REST request methods returning `Result<T, Failure>`, with typed
  decoder-based deserialization and a raw-JSON escape hatch, hiding the underlying Dio.
- `network-failures`: the `Result<S, F>` type and sealed `Failure` taxonomy (network,
  timeout, server, parsing, unauthorized) with the never-raw-exception guarantee.
- `network-interceptors`: auth-token injection, default headers, retry/backoff, and
  flag-controlled request/response logging.
- `network-configuration`: injected `VmNetworkConfig`, the single DI registration entry
  point, and the standalone visual `example/`.

### Modified Capabilities
<!-- None. This is a new module; no existing spec requirements change. -->

## Impact

- New package `packages/vm_network`; added to root `workspace:` list in `pubspec.yaml`.
- New third-party dependency: `dio`. Dev deps: `build_runner`, `freezed`,
  `json_serializable`, `injectable_generator`, `mocktail`/`http_mock_adapter` for tests.
- The `example/` depends on `vm_storyboard`; generic UI components missing from the design
  system may be added to `packages/vm_storyboard` as part of this change.
- Base (Propose 1) monorepo conventions consumed; optional future `vm_logging` (Propose 8)
  will later implement the logging seam. `Result`/`Failure` defined locally now, earmarked
  for `vm_foundation` migration.
- `docs/` index updated to include the new module.
