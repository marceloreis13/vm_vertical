## 1. Scaffold the module

- [x] 1.1 Create `packages/vm_network/` following module-scaffold (`lib/vm_network.dart` barrel, `lib/src/`, `example/`, `test/unit|widget|golden/`)
- [x] 1.2 Add `pubspec.yaml` with `resolution: workspace`, `dio` dependency, and standard dev deps (build_runner, freezed, json_serializable, injectable_generator, mocktail, http_mock_adapter)
- [x] 1.3 Register `packages/vm_network` in the root `pubspec.yaml` `workspace:` list and include the shared `analysis_options.yaml`
- [x] 1.4 Run `dart pub get` / workspace bootstrap and confirm the empty package resolves

## 2. Core primitives (Result + Failure)

- [x] 2.1 Define `Result<S, F>` in `lib/src/core/` as a sealed/Freezed union with exhaustive folding
- [x] 2.2 Define sealed `Failure` taxonomy: `NetworkFailure`, `TimeoutFailure`, `ServerFailure(statusCode, payload?)`, `ParsingFailure`, `UnauthorizedFailure`, `UnknownFailure`
- [x] 2.3 Add a `JsonMap` typedef and any shared core types; keep `core/` isolated for future `vm_foundation` migration
- [x] 2.4 Run build_runner and unit-test Result folding and each Failure variant's context fields

## 3. HTTP client abstraction and Dio implementation

- [x] 3.1 Define abstract `VmHttpClient` with `get/post/put/patch/delete` returning `Result<T, Failure>`, taking path, query, body, header overrides, and a per-call decoder `T Function(Object? json)`
- [x] 3.2 Add the raw variants returning `Result<JsonMap, Failure>` (and list equivalent) for schema-less responses
- [x] 3.3 Implement the Dio-backed client in `lib/src/data/` resolving relative paths against `baseUrl`; ensure no Dio type appears in any public signature
- [x] 3.4 Wrap decoder invocation in try/catch → `ParsingFailure`
- [x] 3.5 Unit-test success decode, raw variant, and parsing-failure path with `http_mock_adapter`

## 4. Error translation

- [x] 4.1 Implement a single translator mapping `DioException`/status codes to the `Failure` taxonomy (timeout, network, 401/403→unauthorized, non-2xx→server, else→unknown)
- [x] 4.2 Unit-test each mapping case, including the unknown/fallback path (assert nothing throws)

## 5. Interceptors

- [x] 5.1 Implement injectable auth-token interceptor (async provider, configurable scheme; no header when provider absent or returns null)
- [x] 5.2 Implement default-headers merging with per-call override precedence
- [x] 5.3 Implement retry/backoff interceptor driven by injected `RetryPolicy`; retry transient only, never 401/403/validation
- [x] 5.4 Implement the logging seam over `dart:developer` (flag-controlled, `Authorization` redacted) behind an internal logger interface
- [x] 5.5 Define a `vm_network` interceptor abstraction (no Dio leak) and support consumer custom interceptors, appended after auth/default-headers and before retry/logging
- [x] 5.6 Unit-test each interceptor: token attach/skip, header override, retry-then-succeed, retries-exhausted, non-retriable, logging on/off, redaction, custom-interceptor effect and ordering

## 6. Configuration and DI

- [x] 6.1 Define `VmNetworkConfig` (baseUrl, default headers, token provider, connect/receive/send timeouts, retry policy, logging flag, optional custom interceptors)
- [x] 6.2 Expose a single registration function in the barrel receiving `VmNetworkConfig`, wiring custom interceptors into the chain, and registering `VmHttpClient` + collaborators (GetIt)
- [x] 6.3 Export only public types from `lib/vm_network.dart`; verify no `src/` leakage and no Dio types
- [x] 6.4 Unit-test registration resolves the client abstraction, that config values drive behavior, and that config custom interceptors reach the client

## 7. Standalone example

- [x] 7.1 Add `vm_storyboard` as a dependency of `example/` and build screens/sections from its components (Screen/Sections/Views), showing success/error/retry states
- [x] 7.2 Wire direct public-API scenario (no auth)
- [x] 7.3 Wire basic-auth scenario (e.g. `httpbin.org/basic-auth`)
- [x] 7.4 Wire bearer-token scenario (e.g. `httpbin.org/bearer`) via the auth interceptor
- [x] 7.5 Wire error scenarios: 404/500 (server), 401 (unauthorized), and timeout (`httpbin.org/delay/<n>` vs short timeout), each showing the typed failure
- [x] 7.6 Wire a retry demo on the 500 scenario and a custom-interceptor demo, making the interceptors' effects observable on screen; keep inputs easy to tweak
- [x] 7.7 Promote any missing generic UI component to `vm_storyboard` (with golden test); keep example-specific pieces local
- [x] 7.8 Confirm `example/` compiles and runs standalone without any `apps/` dependency

## 8. Docs and validation

- [x] 8.1 Add `vm_network` to `docs/` (index + module page: purpose, config injection, usage) per the living-docs rule
- [x] 8.2 Run `dart analyze` and all tests (unit/widget/golden) clean across the workspace
- [x] 8.3 Run `openspec validate --change vm-network` and confirm it passes
