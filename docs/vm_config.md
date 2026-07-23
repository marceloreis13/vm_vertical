# `vm_config`

Injectable, source-agnostic configuration for the vm_core platform: typed
environment, feature flags and remote config behind a single `ConfigReader`
interface. Reads are **synchronous and total** — a value always resolves by
precedence **remote > cache > default**, never throws, and never blocks.
Swapping the remote source (Firebase Remote Config, LaunchDarkly, ...) never
changes a read call site. The module carries **no hard dependency on
`vm_storage`** — caching is an optional injected seam.

## Register at app startup

```dart
final provider = MyFirebaseRemoteConfigProvider(); // implements RemoteConfigProvider
final cache = MyVmStorageBackedConfigCache();       // implements ConfigCache, optional

registerVmConfigModule(
  getIt,
  config: VmConfigConfig(
    provider: provider,
    defaults: {
      'new_checkout': false,
      'max_items': 20,
      'theme': 'light',
    },
    environment: VmEnvironment.prod,
    env: MyAppEnv(baseUrl: 'https://api.example.com'), // app-owned, opaque to vm_config
    cache: cache,
  ),
);
```

Nothing is hard-coded inside the module — the provider, defaults, environment,
app env object and cache always come from the consuming app. Omitting `cache`
still registers and runs fine; precedence simply collapses to remote >
default.

## Read configuration

```dart
final config = getIt<ConfigReader>();

final showNewCheckout = config.getBool('new_checkout', false);
final maxItems = config.getInt('max_items', 10);
final theme = config.getString('theme', 'light');
final layout = config.getJson('layout', const {});

if (config.environment == VmEnvironment.prod) { /* ... */ }
final appEnv = config.env<MyAppEnv>();
```

Every getter takes an inline default and **never fails**: an unresolved key or
a type mismatch (e.g. a remote payload sending a string where a bool is
expected) silently falls back to the default — never a thrown exception,
never a broken screen.

## React to changes

```dart
config.changes.listen((change) {
  if (change.keys.contains('new_checkout')) { /* re-render */ }
});

final stream = config.valueStream('max_items', 10); // emits now, then on change
```

`changes` only emits the keys whose *resolved* value actually changed after a
recompute (i.e. after a successful `refresh()`) — never the full snapshot,
never on a failed or no-op refresh.

## Refresh from the remote source

```dart
final result = await config.refresh();
result.when(
  success: (_) => print('config refreshed'),
  failure: (failure) => print('refresh failed: ${failure.message}'),
);
```

A failing fetch (including a provider that throws) is caught and isolated: it
is reported through the module's `dart:developer`-backed debug seam (earmarked
for `vm_logging` once it exists) and reads keep serving the last good
snapshot, then cache, then defaults — the app never breaks.

## Providers

`RemoteConfigProvider` is the pull-based port every concrete remote source
implements (`Future<Result<ConfigMap, ConfigFailure>> fetch()`). Built in:

- **`LocalConfigProvider`** — contributes no remote values; the reader serves
  only defaults (and cache, if any). The inert default for tests/standalone.
- **`StaticMapConfigProvider`** — an observable, mutable in-memory map.
  `set`/`remove` take effect on the next `refresh()`, letting an app or the
  `example/` toggle flags/values live with no real vendor SDK.

## Cache seam

`ConfigCache` is the optional persistence port (`read()` synchronous,
`write(snapshot)` async). `vm_config` never imports `vm_storage`: an app that
wants durability across restarts implements `ConfigCache` itself (typically
backed by `vm_storage`'s `DocumentStore`/`KeyValueStore`), loading the last
snapshot into memory **before** calling `registerVmConfigModule` so getters
resolve to it immediately — resolution happens synchronously at registration,
before any remote fetch completes. `InMemoryConfigCache` ships built in for
tests and the `example/`.

## Visual example

`packages/vm_config/example/` is a standalone Flutter app demonstrating live
flag/value toggling (an observable `StaticMapConfigProvider`) and the remote >
cache > default precedence — clearing a remote value falls back to cache, then
default, live in the UI. The demo screen (`ConfigDemoScreen`) lives in `lib/`
and is exported by the barrel, so any app can embed it directly via
`package:vm_config/vm_config.dart` — the `example/` app is only a thin shell
that registers the module and runs it.

## Out of scope

Concrete remote sources (Firebase Remote Config, LaunchDarkly, ...) — apps
implement `RemoteConfigProvider`. A flag/config admin console. Realtime/push
updates from a provider (pull-based only for now; a provider can trigger
`refresh()` internally later with no change to `ConfigReader`).
Consent/experimentation/A-B assignment logic.
