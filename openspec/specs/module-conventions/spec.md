## Purpose

Defines the mandatory conventions every `vm_*` module must follow: Clean Architecture layering with Feature-First organization, dependency injection via GetIt + Injectable with configuration injected by the consuming app, the Barrel pattern as the only public API surface, and code generation tooling via `build_runner`.

## Requirements

### Requirement: Layered architecture
Every module SHALL follow Clean Architecture with Feature-First organization, separating `presentation`, `domain` and `data` responsibilities under `src/`, structured per module and per feature.

#### Scenario: Module internal structure
- **WHEN** a module is created
- **THEN** its `src/` separates presentation, domain and data layers, with code grouped feature-first

### Requirement: Dependency injection convention
Every module SHALL expose a single registration entry point (GetIt + Injectable) that receives its configuration injected by the consuming app. Modules MUST NOT hard-code configuration such as keys, endpoints or environment.

#### Scenario: Registering a module with injected config
- **WHEN** an app registers a module
- **THEN** it passes the module's configuration in, and the module resolves its dependencies from the injected values

#### Scenario: No hard-coded configuration
- **WHEN** a module needs a key, endpoint or environment value
- **THEN** that value is received via injection, never hard-coded inside the module

### Requirement: Barrel export as public API
Each package SHALL expose its public API through a single barrel file `lib/<package>.dart`. Code under `src/` MUST be private and MUST NOT be imported from outside the package. This convention MUST be documented in `docs/` and in `CLAUDE.md`.

#### Scenario: Consuming a module
- **WHEN** another package or app imports a module
- **THEN** it imports only `package:vm_<name>/vm_<name>.dart`, never a path under `src/`

#### Scenario: Lint blocks internal imports
- **WHEN** code outside a package imports one of its `src/` files
- **THEN** the shared lint flags it as a violation

### Requirement: Code generation tooling
Modules SHALL use `build_runner` for code generation of models (Freezed / JsonSerializable) and dependency injection (Injectable).

#### Scenario: Generating code for a module
- **WHEN** a module defines Freezed models or Injectable registrations
- **THEN** the corresponding code is produced by `build_runner`, not written by hand
</content>
