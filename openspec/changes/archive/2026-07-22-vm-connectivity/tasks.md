## 1. Scaffold module

- [x] 1.1 Create `packages/vm_connectivity` with the standard scaffold (barrel `lib/vm_connectivity.dart`, private `lib/src/`, `example/`, `test/`), `resolution: workspace`
- [x] 1.2 Add `vm_connectivity` to the root `pubspec.yaml` `workspace:` list
- [x] 1.3 Add deps: `connectivity_plus`, `bloc`/`flutter_bloc`, `get_it`, `injectable`, `freezed_annotation`, `json_annotation`; dev deps: `build_runner`, `freezed`, `injectable_generator`, `bloc_test`, `mocktail`, golden setup
- [x] 1.4 Run `flutter pub get` (workspace) and confirm the package resolves

## 2. Domain: source, state, repository

- [x] 2.1 Define `ConnectionType` and the sealed `ConnectivityState` (`Online(type)` | `Offline`) with derived `isOnline`; `none` maps to `Offline`
- [x] 2.2 Define the abstract `ConnectivitySource` (current type + change stream) in domain; export only abstractions from the barrel
- [x] 2.3 Define the connectivity repository interface that maps the source stream to `ConnectivityState`

## 3. Data: connectivity_plus source

- [x] 3.1 Implement the `connectivity_plus`-backed `ConnectivitySource` in `lib/src/`, mapping platform results to `ConnectionType`; never export `connectivity_plus` types
- [x] 3.2 Implement the repository over the source, emitting initial state then transitions
- [x] 3.3 Implement a `FakeConnectivitySource` (manual toggle) for the example and tests

## 4. Presentation: Cubit and offline banner

- [x] 4.1 Implement `ConnectivityCubit` emitting the initial state and every transition from the repository
- [x] 4.2 Build the offline banner widget (presentation), visible only when `Offline`, composed from `vm_storyboard` primitives/tokens with consumer-overridable copy
- [x] 4.3 Promote any genuinely generic missing primitive to `vm_storyboard`; keep connectivity-specific wiring local

## 5. Configuration and DI

- [x] 5.1 Define `VmConnectivityConfig` (injected `ConnectivitySource`, optional debounce)
- [x] 5.2 Implement the single GetIt + Injectable registration function receiving the config and registering repository + `ConnectivityCubit`
- [x] 5.3 Verify no concrete source or ambient global is hard-coded outside the injectable default wiring

## 6. vm_network bridge (inverted dependency)

- [x] 6.1 In `vm_network`, add an abstract connectivity **gate** (online signal) seam; no import of `vm_connectivity`/`connectivity_plus`
- [x] 6.2 In `vm_network`, add the offline request policy interceptor: hold requests while offline, resume when online, bounded wait failing with a typed offline `Failure`
- [x] 6.3 Add optional connectivity `gate` + offline `policy` fields to `VmNetworkConfig`; absent gate keeps prior behavior; wire into the interceptor chain
- [x] 6.4 In `vm_connectivity`, implement the adapter mapping `ConnectivityState.isOnline` onto the `vm_network` gate

## 7. Standalone example

- [x] 7.1 Build the `example/` app with `vm_storyboard` screens, injecting `FakeConnectivitySource` with a manual online/offline toggle
- [x] 7.2 Reflect state changes in the UI and show/hide the offline banner as the fake source toggles
- [x] 7.3 Demonstrate the vm_network bridge in the example: a request held while offline and resumed when back online

## 8. Tests

- [x] 8.1 Unit: state transitions via the fake source (online→offline→online), initial state on subscription, `none`→`Offline` mapping
- [x] 8.2 Unit (vm_network): request held then resumed; bounded wait fails typed; absent gate is byte-for-byte prior behavior; online requests unaffected
- [x] 8.3 Widget/bloc: banner shows when `Offline` and hides when `Online`
- [x] 8.4 Golden: offline banner appearance

## 9. Docs

- [x] 9.1 Register `vm_connectivity` in `docs/` (index + module page) per the project rule
- [x] 9.2 Document the vm_network offline gate/bridge and the reachability-probing seam as a future extension
- [x] 9.3 Run `dart format`, `dart analyze`, and the full test suite; confirm green
