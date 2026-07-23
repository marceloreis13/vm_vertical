## 1. Scaffold the module

- [x] 1.1 Create `packages/vm_analytics/` following module-scaffold (`lib/vm_analytics.dart` barrel, `lib/src/`, `example/`, `test/unit|widget|golden/`)
- [x] 1.2 Add `pubspec.yaml` with `resolution: workspace`, a hard dependency on `vm_navigation`, and standard dev deps (build_runner, freezed, json_serializable, injectable_generator, mocktail)
- [x] 1.3 Register `packages/vm_analytics` in the root `pubspec.yaml` `workspace:` list and include the shared `analysis_options.yaml`
- [x] 1.4 Run `dart pub get` / workspace bootstrap and confirm the empty package resolves

## 2. AnalyticsEvent value object

- [x] 2.1 Define immutable `AnalyticsEvent` (Freezed) with `name` and typed `parameters` (`Map<String, Object?>`) and value equality
- [x] 2.2 Implement provider-agnostic name validation at construction (snake_case, bounded length, allowed charset); reject invalid names
- [x] 2.3 Add a home for typed factory-constructor conventions (usage doc/example) without coupling the module to app events
- [x] 2.4 Unit-test equality, valid-name acceptance, and invalid-name rejection (spaces/camelCase/over-length)

## 3. Tracker interface and provider port

- [x] 3.1 Define the `AnalyticsTracker` interface: `logEvent(AnalyticsEvent)`, `setUserProperty`, `screenView`, `setUserId`, `reset` — no vendor SDK type in any signature
- [x] 3.2 Define the `AnalyticsProvider` port mirroring the same operations; document that providers own SDK translation
- [x] 3.3 Implement the debug logging seam over `dart:developer` behind an internal logger interface (earmarked for `vm_logging`)
- [x] 3.4 Export only public types from the barrel; verify no `src/` leakage and no vendor types

## 4. Multiplexing tracker implementation

- [x] 4.1 Implement the fan-out `AnalyticsTracker` delivering each call to all registered providers, returning `Future<void>`
- [x] 4.2 Wrap each provider call in its own try/catch so a throwing provider is isolated, reported via the debug seam, and never reaches the caller or aborts the fan-out
- [x] 4.3 Ensure zero-provider registration is a safe no-op
- [x] 4.4 Unit-test with fake providers: delivery to N providers, one-throws-others-still-receive, isolated-failure-logged, no-provider no-op

## 5. Built-in providers

- [x] 5.1 Implement the `noop` provider (accepts every call, does nothing)
- [x] 5.2 Implement the observable `debug` provider: log via `dart:developer` and expose a broadcast stream/buffer of received calls
- [x] 5.3 Unit-test noop inertness and debug logging + observable emission order

## 6. Screen tracking

- [x] 6.1 Implement `AnalyticsRouteObserver` (a `vm_navigation` `NavigatorObserver`) deriving a screen name from route changes and calling `screenView`
- [x] 6.2 Gate automatic tracking behind the config toggle; keep manual `screenView(name)` available and apply the shared name validation to screen names
- [x] 6.3 Unit/widget-test: route change emits a screen view, disabled toggle suppresses it, invalid screen name rejected

## 7. Configuration and DI

- [x] 7.1 Define `VmAnalyticsConfig` (list of providers, their keys, automatic screen-tracking toggle); no hard-coded vendor value in the module
- [x] 7.2 Expose a single registration function (GetIt + Injectable) receiving `VmAnalyticsConfig` and registering the tracker, providers, and route observer
- [x] 7.3 Unit-test registration resolves `AnalyticsTracker`, config providers receive calls, and the screen-tracking toggle is honored

## 8. Standalone example

- [x] 8.1 Add `vm_storyboard` as a dependency of `example/` and build screens/sections from its components (Screen/Sections/Views)
- [x] 8.2 Wire scenarios: dispatch events, set user properties, set/clear user id and reset, and navigate between screens (auto screen tracking)
- [x] 8.3 Render the emitted calls live on-screen from the `debug` provider's observable record; keep inputs easy to tweak
- [x] 8.4 Promote any missing generic UI component to `vm_storyboard` (with golden test); keep example-specific pieces local — no new generic component was needed, the example reuses `VmAppBar`/`VmCard`/`VmButton`/`VmEmptyView`
- [x] 8.5 Confirm `example/` compiles and runs standalone (only `debug`/`noop` providers, no real vendor SDK or key, no `apps/` dependency)

## 9. Docs and validation

- [x] 9.1 Add `vm_analytics` to `docs/` (index + module page: purpose, config injection, event convention, screen tracking, usage) per the living-docs rule
- [x] 9.2 Run `dart analyze` and all tests (unit/widget/golden) clean across the workspace
- [x] 9.3 Run `openspec validate --change vm-analytics` and confirm it passes
