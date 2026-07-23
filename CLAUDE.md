Flutter 3.44

Architecture
- Clean Architecture
- Feature First

State Management
- Cubit

DI
- GetIt
- Injectable

Routing
- go_router

Model
- Freezed
- JsonSerializable

Testing
- Unit
- Widget
- Golden

Monorepo
- Pub Workspace (`apps/`, `packages/`, `docs/`, `openspec/`); one lockfile, single source of truth per dependency.
- Barrel pattern: each package's public API is `lib/<name>.dart`; `lib/src/` is private and never imported from outside the package (enforced by the shared lint's `implementation_imports` rule).
- DI: each module exposes one registration function (GetIt + Injectable) that receives its config injected by the consuming app; no hard-coded config inside modules.
- Living docs in `docs/` (start at `docs/index.md`): update every time a module is added. See `docs/conventions.md` and `docs/module-scaffold.md`.

Coding standards (skills)
These skills define how code is written and are loaded automatically when relevant. Follow them when implementing modules/features (including during /opsx:apply).
- vm-clean-architecture — layering (presentation/domain/data), dependency rule, DI, barrel, Result/Failure
- vm-dart-idioms — modern idiomatic Dart (sealed unions, pattern matching, immutability, async)
- vm-ddd-modular — domain modeling and module boundaries (entities, value objects, aggregates, repositories)
- vm-ui-composition — presentation/<feature>/ split by responsibility (Screen/Sections/Views), promotion rule, per-tier testing
- vm-testing — unit/widget/golden conventions per layer and per presentation tier

Commits
- Every commit message has 1 to 2 lines of text.
- Always concise, clear and objective, written in English.

