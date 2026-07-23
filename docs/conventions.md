# Conventions

These conventions are mandatory for every `vm_*` package under `packages/` and
every app under `apps/`. They are what makes modules decoupled, standalone and
combinable on demand.

## Clean Architecture + Feature-First

Every module's `lib/src/` separates three layers:

- `presentation/` — Cubits, states (Freezed), widgets/pages.
- `domain/` — entities, value objects, repository interfaces, use cases. No
  Flutter, no data-source imports.
- `data/` — repository implementations, data sources, DTOs (JsonSerializable),
  mappers from DTO to domain entity.

Inside each layer, code is grouped **feature-first**: a feature owns its own
`presentation/<feature>/`, `domain/<feature>/`, `data/<feature>/` slice, rather
than being split by technical type across the whole module.

The dependency rule applies: `presentation` depends on `domain`; `data`
depends on `domain`; `domain` depends on nothing else in the module.

## UI composition (Screen / Sections / Views)

Inside `presentation/<feature>/`, widgets are split into three tiers by
**responsibility**, never by size:

- **`screen/`** — the feature's entry point. Binds the Cubit, composes
  Sections, wires navigation.
- **`sections/`** — reads this feature's `State` and orchestrates a slice of
  the screen's flow (which Views appear together, when to show an error).
  Specific to this feature; never promoted or reused elsewhere.
- **`views/`** — takes plain parameters/callbacks only, no `Cubit`/`State`/
  repository. Resolves a reusable UI pattern; promote to `vm_storyboard` (if
  fully generic) or a shared package (if app-specific but cross-feature) the
  moment it repeats in a second feature.

Cross-feature imports between two `presentation/<feature>/` folders are not
allowed — promote the shared View instead.

**Every text input's keyboard must match its purpose** — email fields get
`TextInputType.emailAddress`, phone fields get `.phone`, numeric fields get
`.number`, and so on; never the default text keyboard "because it still
works." A generic field (`VmTextField`-shaped) exposes
`keyboardType`/`textInputAction` for the caller to set; a purpose-built field
(`VmSearchField`-shaped) hard-codes the right one itself.

See the `vm-ui-composition` skill for the full decision criteria and how each
tier is tested (Views: standalone/golden; Sections: state-driven widget
tests; Screen: shallow integration tests).

## Dependency Injection (GetIt + Injectable)

Each module exposes a **single registration entry point** in its barrel, for
example:

```dart
void registerVmNetworkModule(GetIt getIt, {required VmNetworkConfig config}) {
  getIt.registerSingleton<VmNetworkConfig>(config);
  // ...Injectable-generated registrations that depend on it
}
```

- The config (keys, endpoints, environment, feature flags) is **always
  received as a parameter**, supplied by the consuming app.
- Modules **must not** hard-code configuration or read global/ambient state.
- `build_runner` + `injectable_generator` produce the generated registration
  code inside the module; the app only calls the module's registration
  function with its config.

## Barrel pattern

Each package exposes its public API through a single barrel file,
`lib/<package>.dart`. Everything under `lib/src/` is private implementation.

- Consumers import only `package:vm_<name>/vm_<name>.dart`, never a path under
  `src/`.
- This is enforced by the shared lint (`analysis_options.yaml` at the
  workspace root, via the `implementation_imports` rule). Any import reaching
  into another package's `src/` is flagged as an analyzer error.
- Member packages include the shared rules with:
  ```yaml
  include: ../../analysis_options.yaml
  ```

## Code generation

Modules use `build_runner` for:

- **Freezed** — immutable models and unions (domain entities, value objects,
  Cubit states).
- **JsonSerializable** — DTOs at the data layer boundary.
- **Injectable** — DI registration wiring.

Standard scaffold dev dependencies for a `vm_*` package:

```yaml
dev_dependencies:
  build_runner: ^2.4.0
  freezed: ^2.5.0
  json_serializable: ^6.8.0
  injectable_generator: ^2.6.0
```

See [module-scaffold.md](module-scaffold.md) for the full package layout.
