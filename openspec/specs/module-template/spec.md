## Purpose

Defines the documented scaffold convention every `vm_*` module follows: barrel, layered `src/`, a standalone runnable `example/` with manipulable mocks (including a visual simulation for infrastructure modules), and a `test/` directory set up for unit, widget and golden tests.

## Requirements

### Requirement: Standard module scaffold
Every module SHALL follow the standard scaffold: a barrel (`lib/<name>.dart`), a layered `src/`, a runnable `example/`, and a `test/` directory. The scaffold is defined as a documented convention in `docs/`.

#### Scenario: Creating a module by the convention
- **WHEN** a new module is created following the documented scaffold
- **THEN** it contains the barrel, `src/` layers, `example/` and `test/` in the standard layout

### Requirement: Standalone runnable example with manipulable mocks
Each module SHALL provide an `example/` that compiles and runs on its own. When the module requires external inputs, the `example/` MUST supply mocked data that is easily manipulated, so the standalone build succeeds and supports experimentation without real credentials or services.

#### Scenario: Running a module in isolation
- **WHEN** a developer builds a module's `example/`
- **THEN** it compiles and runs standalone, without depending on any app

#### Scenario: Module that needs inputs
- **WHEN** a module requires external data or credentials to run
- **THEN** its `example/` provides easily manipulated mocked data so the standalone build succeeds and can be experimented with

### Requirement: Visual example for infrastructure modules
For modules that have no visible UI of their own (for example networking or navigation), the `example/` SHALL provide a visual simulation that demonstrates the module in action.

#### Scenario: Infrastructure module example
- **WHEN** a module such as network or navigation is scaffolded
- **THEN** its `example/` renders a visual simulation of the module's behavior, not just a blank or non-visual harness

### Requirement: Test conventions
Every module SHALL include tests following the project convention: unit, widget and golden tests under `test/`.

#### Scenario: Scaffolded test types
- **WHEN** a module is created from the scaffold convention
- **THEN** its `test/` is set up for unit, widget and golden tests
</content>
