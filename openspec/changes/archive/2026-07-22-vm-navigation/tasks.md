## 1. Scaffold

- [x] 1.1 Create `packages/vm_navigation` per module-scaffold (barrel `lib/vm_navigation.dart`, `lib/src/`, `example/`, `test/`, `resolution: workspace`)
- [x] 1.2 Add package to root `workspace:` list in `pubspec.yaml`
- [x] 1.3 Add deps (`go_router`) and dev deps (`build_runner`, `freezed`, `json_serializable`, `injectable_generator`, `mocktail`); include shared `analysis_options.yaml`

## 2. Route Registration

- [x] 2.1 Define the typed route contract (base type/mixin for module-declared routes with typed path params) in `lib/src/routing/`
- [x] 2.2 Define the module route-list convention: a function/class returning `List<RouteBase>` per module
- [x] 2.3 Implement the app-side aggregation helper that concatenates route lists from activated modules into `GoRouter` config
- [x] 2.4 Unit tests: two independent fake modules aggregate without referencing each other; removing one module's list leaves the other's routes intact

## 3. Route Guards

- [x] 3.1 Define the generic `RouteGuard` contract (sync/async predicate returning bool or `Result`) in `lib/src/guards/`
- [x] 3.2 Support attaching one or more guards to a route (logical AND)
- [x] 3.3 Verify no dependency on `vm_auth`/`vm_config` (module compiles standalone)
- [x] 3.4 Unit tests: single guard pass/fail, multiple guards AND semantics, async guard resolution

## 4. Conditional Redirect

- [x] 4.1 Wire guard evaluation into `go_router`'s `redirect` callback, redirecting to a per-guard configured fallback route on failure
- [x] 4.2 Ensure allowed routes build normally with no redirect side effects
- [x] 4.3 Unit tests: blocked route redirects to fallback; allowed route renders; no external URI parsing is performed

## 5. Navigator Service

- [x] 5.1 Define the navigator service interface (`push`/`pop`/`replace`/`go`) accepting typed routes in `lib/src/navigation/`
- [x] 5.2 Implement the service backed by a root `GlobalKey<NavigatorState>` (or root `StatefulNavigationShell` where present)
- [x] 5.3 Register the service in GetIt via the module's single registration entry point
- [x] 5.4 Unit/widget tests: each operation drives navigation correctly; a fake Cubit calls the service with no `BuildContext`

## 6. Example App

- [x] 6.1 Build `example/` with three screens: guard toggle (in-memory logged-in/out state), protected/redirecting route, Cubit-driven navigation via the navigator service
- [x] 6.2 Wire routes from the example through the module's route-list + aggregation pattern
- [x] 6.3 Integrate `vm_storyboard` for transitions/theme in the example (optional dependency, not required by the module core)
- [x] 6.4 Promote any missing generic UI component to `vm_storyboard` if needed
- [x] 6.5 Confirm the example runs end to end (guard toggle changes redirect outcome, Cubit navigation works) on a simulator/device

## 7. Docs & Verification

- [x] 7.1 Add `docs/vm_navigation.md` and update `docs/index.md` per project rule
- [x] 7.2 Run `dart analyze` (barrel/implementation-imports clean) and `dart format`
- [x] 7.3 Run `build_runner` and the full test suite (unit + widget); ensure green
