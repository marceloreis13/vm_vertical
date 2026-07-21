---
name: vm-clean-architecture
description: Use when creating or structuring a Flutter/Dart feature or vm_* module — organizing presentation/domain/data layers, applying the dependency rule, and writing entities, value objects, repositories, use cases, Cubits and states, DI registration, and data-to-domain mappers. Apply during OpenSpec /opsx:apply and any module or feature implementation in this project.
metadata:
  author: vm_core
  version: "1.0"
---

# Clean Architecture (vm_core)

How every `vm_*` module and app feature is layered in this project. This encodes the
`module-conventions` spec as concrete coding guidance. Pair with `vm-dart-idioms` (how to
write the Dart) and `vm-ddd-modular` (how to model the domain and module boundaries).

Copy the skeleton in `references/` and fill it in. Do not invent a different structure.

## The dependency rule

Dependencies point inward only: `presentation → domain ← data`.

- `domain` is the core. It depends on **nothing** (no Flutter, no data, no packages with
  side effects). Pure Dart.
- `data` and `presentation` depend on `domain`, never on each other.
- Concrete classes depend on **abstractions declared in `domain`** (repository interfaces),
  wired at runtime by DI.

If `domain` needs to import from `data` or `presentation`, the design is wrong.

## Layers (feature-first inside `lib/src/`)

```
lib/
  <module>.dart              # barrel: only the public API
  src/
    <feature>/
      domain/                # entities, value objects, failures, repo interfaces, use cases
      data/                  # models (JSON), mappers, datasources, repo implementations
      presentation/          # cubit + state, widgets
```

### domain (pure Dart)
- **Entities**: immutable, identity-based. Use Freezed. No JSON, no framework.
- **Value objects**: immutable, equality by value; validate in the constructor/factory.
- **Failures**: a sealed failure type per module (no raw exceptions crossing layers).
- **Result**: return `Result<T>` (a sealed success/failure), never throw across a boundary.
- **Repository interfaces**: abstract, expressed in domain terms, returning `Result<T>`.
- **Use cases** (optional): one action each, when logic is more than a passthrough. A Cubit
  MAY call a repository directly for trivial reads.

### data (talks to the outside world)
- **Models**: `@JsonSerializable` DTOs that mirror the wire/storage shape.
- **Mappers**: convert model ⇄ entity. The domain never sees a model.
- **Datasources**: raw IO (network via vm_network, storage via vm_storage, etc.), injected.
- **Repository implementations**: implement the domain interface, catch IO errors and map
  them to domain `Failure`, return `Result<T>`.

### presentation (Flutter)
- **Cubit**: orchestrates use cases/repositories, exposes state. No business rules of its own.
- **State**: a sealed/Freezed union (initial, loading, loaded, error). No mutable fields.
- **Widgets**: render state, dispatch intents. No data access, no mapping, no IO.

## DI and public API

- Each module exposes a single registration function that **receives its config injected**
  by the app and registers its graph in GetIt (with Injectable). Nothing hard-coded.
- Only the barrel `lib/<module>.dart` is public. `src/` is private and MUST NOT be imported
  from outside the package.

## Do / Don't

- DO keep `domain` free of Flutter and of any `data`/`presentation` import.
- DO return `Result<T>` from repositories; map IO errors to a domain `Failure`.
- DO map models to entities at the `data` boundary; never leak a model into `domain`/`presentation`.
- DO put orchestration in the Cubit and business rules in `domain`.
- DON'T let a Widget call a repository, datasource, or mapper directly.
- DON'T throw exceptions across layer boundaries.
- DON'T register concrete classes where an interface exists; depend on the abstraction.
- DON'T add config as a global/singleton inside the module; receive it injected.

## Checklist (before calling a feature done)

- [ ] `domain` imports nothing from `data`/`presentation` and no Flutter.
- [ ] Entities/value objects/state are immutable (Freezed); state is a sealed union.
- [ ] Repository interface lives in `domain` and returns `Result<T>`; impl lives in `data`.
- [ ] Models ⇄ entities via mappers; no model escapes `data`.
- [ ] Cubit has no IO and no mapping; widgets only render/dispatch.
- [ ] DI registration receives injected config; only the barrel is exported.
- [ ] Unit tests on domain/repository, widget + golden on presentation.

## References (copy these)

- `references/structure.md` — the folder tree to reproduce.
- `references/domain.dart` — entity, value object, failure, `Result`, repository interface.
- `references/data.dart` — model + mapper + repository implementation.
- `references/presentation.dart` — cubit + sealed state + widget.
- `references/registration.dart` — DI registration function + barrel example.
