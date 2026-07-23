## 1. Module scaffold

- [x] 1.1 Create `packages/vm_config` with barrel `lib/vm_config.dart`, private `lib/src/`, and `resolution: workspace` in `pubspec.yaml`
- [x] 1.2 Add `vm_config` to the root `workspace:` list in `pubspec.yaml`
- [x] 1.3 Add dev deps: `build_runner`, `freezed`, `json_serializable`, `injectable_generator`, `mocktail`; wire the shared analysis options
- [x] 1.4 Create the `example/` shell app skeleton depending on `vm_storyboard`

## 2. Core types and failures

- [x] 2.1 Define the sealed `ConfigFailure` taxonomy in `lib/src/core/` (remote-fetch, cache-access variants), isolated for a future `vm_foundation` re-home
- [x] 2.2 Define local `Result<S, F>` usage for the fetch/refresh path (reuse the project's Result idiom)
- [x] 2.3 Define `VmEnvironment` enum (`dev`/`staging`/`prod`)
- [x] 2.4 Add the `dart:developer`-backed logging seam for isolated failures (earmarked for `vm_logging`)

## 3. Provider port and built-ins

- [x] 3.1 Define the pull-based `RemoteConfigProvider` port with `fetch()` returning a snapshot or `ConfigFailure`
- [x] 3.2 Implement the built-in `local` provider (contributes no remote values)
- [x] 3.3 Implement the observable `static-map` provider (mutable in-memory map, emits on refresh)
- [x] 3.4 Unit tests: provider fetch success, fetch failure surfaced as `ConfigFailure`, static-map mutation

## 4. Cache seam

- [x] 4.1 Define the `ConfigCache` port (read/write last snapshot) with no `vm_storage` import
- [x] 4.2 Implement an in-memory `ConfigCache` for tests/example; document the `vm_storage`-backed wiring for apps
- [x] 4.3 Unit tests: snapshot persisted on successful refresh; cached snapshot loaded before first fetch

## 5. Resolution engine

- [x] 5.1 Implement the resolution engine holding the resolved snapshot with precedence remote > cache > default
- [x] 5.2 Resolve defaults (and cache) synchronously at registration so getters are valid before first fetch
- [x] 5.3 Implement change diffing: recompute snapshot, emit only keys whose resolved value changed
- [x] 5.4 Unit tests: precedence (remote>cache>default), fallback on missing keys, only-changed-keys emitted, failed refresh emits nothing

## 6. ConfigReader interface

- [x] 6.1 Define `ConfigReader` with synchronous typed getters `getBool`/`getInt`/`getDouble`/`getString`/`getJson` (key + inline default)
- [x] 6.2 Implement total reads: type mismatch and missing key fall back to default, never throw
- [x] 6.3 Expose the active `VmEnvironment` and the app-injected typed env object (held generically)
- [x] 6.4 Expose `refresh()` returning `Result<Unit, ConfigFailure>` with fetch-failure isolation and fallback
- [x] 6.5 Expose `changes` broadcast stream and `valueStream<T>(key, default)`
- [x] 6.6 Unit tests: getters, never-fail reads, refresh success/failure, valueStream re-emission

## 7. Configuration and DI

- [x] 7.1 Define `VmConfigConfig` (provider, defaults map, environment, injected env object, optional `ConfigCache`)
- [x] 7.2 Implement the single Injectable registration function `registerVmConfigModule(getIt, config:)`
- [x] 7.3 Export the public surface from the barrel; verify nothing under `lib/src/` is reachable
- [x] 7.4 Unit tests: registration wires `ConfigReader`/environment; cache omitted still registers

## 8. Standalone example

- [x] 8.1 Build the `example/` screen (via `vm_storyboard`) with a static-map provider toggling flags/values, reflecting live via the change stream
- [x] 8.2 Demonstrate remote > cache > default precedence in the example UI
- [x] 8.3 Promote any missing generic UI component to `vm_storyboard`
- [x] 8.4 Widget/golden tests for the example screen per the vm-testing conventions

## 9. Docs and validation

- [x] 9.1 Add `docs/vm_config.md` and register the module in `docs/index.md`
- [x] 9.2 Run `dart analyze` / format and `flutter test` across the package; ensure golden/widget/unit pass
- [x] 9.3 Run `openspec validate --change vm-config` and confirm it passes
