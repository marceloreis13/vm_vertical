---
description: Scaffold a new vm_* module package following the project conventions and vm-* skills.
argument-hint: <module-name> (e.g. weather, storage)
---

Scaffold a new reusable module as a package under `packages/`.

Module name from arguments: `$ARGUMENTS`
- Normalize to snake_case and prefix with `vm_` (e.g. `weather` -> `vm_weather`).
- If `$ARGUMENTS` is empty, ask the user for the module name before doing anything.

Load and follow these skills while scaffolding: **vm-clean-architecture**, **vm-dart-idioms**,
**vm-ddd-modular**, **vm-testing**. Do not invent a different structure.

Prerequisite: the Pub Workspace must exist (the `bootstrap-monorepo` change applied). If
`packages/` or the root `workspace:` is missing, tell the user to apply the base first.

## Steps

1. Create `packages/vm_<name>/` with:
   - `pubspec.yaml` — a workspace member (`resolution: workspace`); dependencies as needed by
     the module (flutter, freezed_annotation, json_annotation, get_it, injectable, flutter_bloc);
     dev_dependencies: build_runner, freezed, json_serializable, injectable_generator, flutter_test.
   - `lib/vm_<name>.dart` — the barrel; export only the public API.
   - `lib/src/<feature>/` with `domain/`, `data/`, `presentation/` following vm-clean-architecture
     (entity + value objects, failures + `Result`, repository interface; model + mapper + repo impl;
     cubit + sealed state + widget). Use one sample feature so the module compiles.
   - `lib/src/di/<name>_registration.dart` — registration function receiving injected config.
   - `example/` — a runnable app that wires the module with mocked data (manipulable mocks).
   - `test/` — unit + widget + golden per vm-testing, mirroring `src/`.

2. Register the new package as a member in the root workspace `pubspec.yaml`.

3. Run `dart pub get` at the root, then `dart run build_runner build --delete-conflicting-outputs`
   inside the package to generate Freezed/JSON/Injectable code.

4. Verify: `dart analyze` clean for the package, and the `example/` builds.

5. Update `docs/` (index + a short page for the module: what it is, how to use it, how to inject
   its config), per the update-per-module rule.

Keep the module fully decoupled: no hard-coded config, only the barrel is public, `src/` stays
private. Report what you created and the next step (implement the real feature).
