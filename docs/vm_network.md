# `vm_network`

Generic, injectable HTTP client for the vm_core platform. Every request returns
a typed `Result<T, Failure>` — network, timeout, server, parsing and
unauthorized errors are always typed, never raw exceptions. The underlying
transport (Dio) is an implementation detail: no Dio type crosses the barrel.

## Register at app startup

```dart
registerVmNetworkModule(
  getIt,
  config: VmNetworkConfig(
    baseUrl: 'https://api.example.com',
    defaultHeaders: {'Accept': 'application/json'},
    tokenProvider: () async => authRepository.currentToken, // or null
    authScheme: 'Bearer', // default
    connectTimeout: const Duration(seconds: 10), // default
    receiveTimeout: const Duration(seconds: 10), // default
    sendTimeout: const Duration(seconds: 10), // default
    retryPolicy: const RetryPolicy(), // 3 attempts, retries 502/503/504
    enableLogging: true, // dart:developer, Authorization redacted
    customInterceptors: [MyCorrelationIdInterceptor()],
  ),
);
```

`baseUrl` is the only required field. Nothing here is hard-coded inside the
module — the config always comes from the consuming app.

## Use the client

Resolve `VmHttpClient` from the container and pass a per-call decoder — a
generated `fromJson` works directly:

```dart
final client = getIt<VmHttpClient>();

final result = await client.get<User>(
  'users/1',
  decoder: (json) => User.fromJson(json as Map<String, dynamic>),
);

result.when(
  success: (user) => print('Got ${user.name}'),
  failure: (failure) => switch (failure) {
    NetworkFailure() => print('No connectivity: ${failure.message}'),
    TimeoutFailure() => print('Timed out: ${failure.message}'),
    ServerFailure(:final statusCode) => print('Server error $statusCode'),
    UnauthorizedFailure() => print('Needs re-auth'),
    ParsingFailure() => print('Bad response shape: ${failure.message}'),
    UnknownFailure() => print('Unexpected: ${failure.message}'),
  },
);
```

`post`/`put`/`patch`/`delete` share the same shape (`path`, optional `query`,
`body`, per-call `headers` that override the configured defaults, required
`decoder`). Decoder exceptions are caught internally and returned as
`ParsingFailure` — they never propagate.

For schema-less or dynamic responses, skip the decoder:

```dart
final raw = await client.getRaw('search'); // Result<JsonMap, Failure>
final rawList = await client.getRawList('items'); // Result<List<JsonMap>, Failure>
```

## Interceptors

Built in, in this fixed order — auth → default headers → custom (in the
order supplied) → retry → logging:

- **Auth token**: attaches `Authorization: <authScheme> <token>` when
  `tokenProvider` returns a non-null token; omitted entirely otherwise.
- **Default headers**: merged into every request; a per-call `headers` entry
  with the same key wins.
- **Retry/backoff**: driven by `RetryPolicy` (`maxAttempts`, `backoff`,
  `retriableStatusCodes`). Retries network/timeout failures and the
  configured status codes only — never 401/403. Use `RetryPolicy.none()` to
  disable retries entirely.
- **Logging**: only when `enableLogging` is true; logs via `dart:developer`
  with the `Authorization` header value redacted. A thin seam so a future
  `vm_logging` module can back it without touching the client.
- **Custom interceptors**: implement `VmNetworkInterceptor` (`onRequest(VmRequestContext)`)
  and pass instances via `VmNetworkConfig.customInterceptors` — no Dio import
  needed in the consuming app.

## Offline gate bridge

`vm_network` owns its own abstract connectivity signal, `VmConnectivityGate`
(`isOnline` + `onlineChanges`), and an `OfflineGateInterceptor` — the module
never imports `vm_connectivity` or any concrete connectivity package. When
`VmNetworkConfig.gate` is configured, the interceptor holds outbound requests
while the gate reports offline and resumes them once it reports online
again, bounded by `VmNetworkConfig.offlinePolicy.maxWait`; exceeding the
bound completes the request with a typed `OfflineFailure`, never a raw
exception. When `gate` is omitted (the default), the client behaves exactly
as before — no offline gating, byte-for-byte prior behavior.

`vm_connectivity` ships the concrete adapter (`VmConnectivityNetworkGateAdapter`)
mapping its own `ConnectivityState.isOnline` onto this gate; the consuming
app wires it into `VmNetworkConfig.gate` in its composition root — see
[vm_connectivity.md](vm_connectivity.md#bridge-into-vm_network-inverted-dependency).
This keeps the dependency inverted: `vm_network` stays lower-level and
connectivity-agnostic.

## Visual example

`packages/vm_network/example/` is a standalone Flutter app (no `apps/`
dependency) demonstrating every scenario above against `httpbin.org`: a
direct public-API call, Basic auth, a bearer-token call via the auth
interceptor, 404/500/401/timeout failures, a retry demo, and a custom
interceptor whose header is echoed back by the server. The demo screen
(`NetworkDemoScreen`) lives in `lib/` and is exported by the barrel, so any
app can embed it directly via `package:vm_network/vm_network.dart` — the
`example/` app is only a thin shell that registers the module and runs it.

## Local `Result`/`Failure`

`Result<S, F>` and the sealed `Failure` taxonomy are defined locally in
`lib/src/core/`, isolated so a future `vm_foundation` migration is a re-home
rather than a rewrite. Consumers should only depend on the barrel-exported
types, not reach into `lib/src/`.
