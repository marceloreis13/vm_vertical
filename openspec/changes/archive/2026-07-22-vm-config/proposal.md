## Why

Apps and modules in the monorepo need a single, injectable source of configuration —
typed environment settings, feature flags, and remote config — so behaviour and whole
modules can be toggled without a deploy. Without one, every consumer reads config from an
ad-hoc place (raw `--dart-define`, a vendor SDK like Firebase Remote Config, scattered
constants), leaking that source into call sites and making a flag flip a code change. This
change delivers `vm_config`: a source-agnostic configuration layer where the app injects
the remote provider, the environment, and the local defaults, and modules read flags and
values through one interface without knowing where they came from.

## What Changes

- New `packages/vm_config` module following the standard scaffold (barrel, `lib/src/`,
  `example/`, three test kinds, `resolution: workspace`).
- **`ConfigReader` interface** — the single API consumers depend on. Synchronous typed
  getters `getBool`, `getInt`, `getDouble`, `getString`, `getJson`, each taking a key and
  an inline default. Reads never fail and never block: a value always resolves by the
  precedence **remote > cache > default**. No vendor SDK type appears in the public API.
- **Observable changes** — `changes` (a broadcast `Stream<ConfigChange>` of the keys whose
  resolved value changed) plus `valueStream<T>(key, default)`, so modules react to flag
  flips at runtime. Changes are emitted after a successful `refresh()` recomputes the
  resolved snapshot.
- **Pluggable remote provider (pull-based)** — a `RemoteConfigProvider` port with
  `fetch()`; the module owns validation, snapshot resolution, and multiplexing default →
  cache → remote. `refresh()` triggers a fetch and returns `Result<Unit, ConfigFailure>`;
  a failed fetch is isolated and the reader keeps serving cache/defaults — the app never
  breaks. Realtime/push from a provider is an optional future seam, not required now.
- **Built-in providers** — a `local` provider (inert, serves only injected defaults, for
  tests/standalone) and an observable `static-map` provider whose in-memory map can be
  mutated at runtime, so the `example/` can toggle flags and watch the UI react without a
  real vendor SDK.
- **Typed environment** — a `VmEnvironment` enum (`dev`/`staging`/`prod`) resolved from the
  injected config, plus a holder for an **app-defined, app-owned typed env object** the app
  injects. `vm_config` exposes the active environment and the app's env object without
  knowing its fields; no app-specific value lives in the module.
- **Injectable cache seam** — a `ConfigCache` port (no hard dependency on `vm_storage`). The
  app optionally wires an implementation backed by `vm_storage` to persist the last remote
  snapshot and survive restarts; with no cache wired, precedence collapses to remote >
  default. The module never imports `vm_storage`.
- **Injected configuration** — `VmConfigConfig` (remote provider, local defaults map,
  environment, optional cache, injected env object) supplied by the consuming app through a
  single DI registration entry point (GetIt + Injectable). No source, key, or app value
  lives in the module.
- **Standalone `example/`** — a visual app (built with `vm_storyboard`) with a local
  provider that toggles flags/values and reflects them live in the UI, demonstrating the
  observable change stream and the remote > cache > default precedence. Any missing generic
  UI component is promoted to `vm_storyboard`.
- Living docs: register `vm_config` in `docs/` per project rule.

## Capabilities

### New Capabilities
- `config-reader`: the `ConfigReader` interface — synchronous typed getters
  (`getBool`/`getInt`/`getDouble`/`getString`/`getJson`) with inline defaults, the
  never-failing read contract, the observable `changes` stream and `valueStream`, and the
  local `ConfigFailure` taxonomy. The source-free contract consumers depend on.
- `config-providers`: the pluggable pull-based `RemoteConfigProvider` port, `refresh()`
  returning `Result<Unit, ConfigFailure>` with fetch-failure isolation and fallback, and
  the built-in `local` and observable `static-map` providers.
- `config-resolution`: the resolution engine enforcing precedence **remote > cache >
  default**, the injectable `ConfigCache` seam (snapshot persistence, no `vm_storage`
  dependency), and change detection that feeds the observable stream.
- `config-environment`: the `VmEnvironment` enum resolution and the holder for the
  app-defined, app-injected typed env object, kept generic to the module.
- `config-configuration`: the injected `VmConfigConfig`, the single DI registration entry
  point, and the standalone visual `example/`.

### Modified Capabilities
<!-- None. This is a new module; no existing spec requirements change. -->

## Impact

- New package `packages/vm_config`; added to the root `workspace:` list in `pubspec.yaml`.
- **No hard dependency on `vm_storage`**: caching is an injected `ConfigCache` seam; an app
  that wants persistence wires a `vm_storage`-backed implementation itself.
- Dev deps: `build_runner`, `freezed`, `json_serializable`, `injectable_generator`,
  `mocktail` (fake providers/cache for resolution and precedence unit tests).
- Logging of isolated fetch failures uses `dart:developer` via a seam, to be re-homed onto
  `vm_logging` (a later change) when it exists.
- The `example/` depends on `vm_storyboard`; generic UI components missing from the design
  system may be added to `packages/vm_storyboard` as part of this change.
- `docs/` index updated to include the new module.
- Base (Propose 1) monorepo conventions consumed. Concrete remote sources (Firebase Remote
  Config, LaunchDarkly, …) are **out of scope**; this change ships only `local` and
  `static-map`. A flag/config admin console is out of scope.
