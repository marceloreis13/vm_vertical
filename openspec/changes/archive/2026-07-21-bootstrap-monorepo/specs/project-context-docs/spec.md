## ADDED Requirements

### Requirement: Living context documentation
The project SHALL maintain a living documentation base under `docs/` that describes the available modules, how each module is used, and how to inject its configuration. It MUST contain an initial context index, ready to grow.

#### Scenario: Reading project context
- **WHEN** someone (or an AI assistant) starts working on the project
- **THEN** `docs/` provides an initial index of what exists and how each module is used and configured

#### Scenario: Conventions are documented
- **WHEN** a developer looks for the Barrel and DI conventions
- **THEN** they are documented in both `docs/` and `CLAUDE.md`

### Requirement: Update-per-module rule
The `docs/` context SHALL be updated whenever a new module is created, so future work consumes accumulated context instead of rebuilding it.

#### Scenario: New module updates docs
- **WHEN** a new module is completed
- **THEN** the `docs/` context is updated to include it, keeping the documentation in sync with the codebase
