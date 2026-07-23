## ADDED Requirements

### Requirement: Standalone runnable example
The module SHALL ship a standalone `example/` app, compiling and running independently of any other module or consuming app, demonstrating a language selector that switches date/number/currency formats at runtime across `pt_BR` (default) and `en`. The demo screen SHALL live in `lib/`, exported by the barrel, so any app can embed it directly; `example/` SHALL be only a thin shell that registers the module and runs the screen.

#### Scenario: Example compiles and runs standalone
- **WHEN** the `example/` app is run on its own (no other module's demo screen involved)
- **THEN** it builds and runs, exercising `vm_localization`'s full public API

#### Scenario: Switching language updates displayed formats
- **WHEN** the language selector is used to switch from `pt_BR` to `en`
- **THEN** the displayed date/number/currency examples update to reflect `en`'s conventions
