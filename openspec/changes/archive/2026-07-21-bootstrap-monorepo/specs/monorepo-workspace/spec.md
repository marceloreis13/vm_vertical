## ADDED Requirements

### Requirement: Repository layout
The repository SHALL organize code into `apps/` for final applications, `packages/` for reusable `vm_*` modules, `openspec/` for SDD artifacts, and `docs/` for living context. Reusable code MUST live under `packages/`, never inside an app.

#### Scenario: Creating a new module
- **WHEN** a new reusable capability is needed
- **THEN** it is created as a package under `packages/vm_<name>/`, not inside an app

#### Scenario: Creating a new app
- **WHEN** a new application is created
- **THEN** it is placed under `apps/<app_name>/` and consumes modules from `packages/`

### Requirement: Pub Workspace with single-source dependencies
The monorepo SHALL be managed as a Pub Workspace that orchestrates bootstrap, analysis, tests and versioning across packages, resolving every transitive dependency to a single version with one lockfile at the repository root.

#### Scenario: Two modules share a dependency
- **WHEN** two packages declare the same third-party dependency
- **THEN** the workspace resolves it to a single shared version, with no duplication or conflict

#### Scenario: Adding a workspace member
- **WHEN** a new package or app is added under `packages/` or `apps/`
- **THEN** it is registered as a workspace member and participates in the shared resolution

#### Scenario: Dependencies are explicit and duplication-free
- **WHEN** an app assembles the modules it needs
- **THEN** inter-module dependencies are explicit and no dependency is duplicated across the app
