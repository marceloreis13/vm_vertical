## Purpose

Define the typed environment enum and the generic, app-owned environment object exposed by the config module.

## Requirements

### Requirement: Typed environment enum
The module SHALL define a `VmEnvironment` enum with `dev`, `staging` and `prod` values and
SHALL resolve the active environment from the injected configuration. `ConfigReader` (or a
sibling accessor) SHALL expose the active `VmEnvironment` so consumers can branch on it.

#### Scenario: Active environment is exposed
- **WHEN** the module is configured with `VmEnvironment.staging`
- **THEN** consumers read the active environment as `staging`

#### Scenario: Consumer branches on environment
- **WHEN** a module needs environment-specific behaviour
- **THEN** it reads the active `VmEnvironment` from the module rather than a raw string or
  `--dart-define`

### Requirement: App-defined injected env object held generically
The module SHALL hold an app-defined, app-owned typed environment object supplied through
configuration and expose it back to consumers, without the module knowing the object's
fields. The module SHALL NOT declare or hard-code any app-specific environment field
(base URLs, keys, etc.).

#### Scenario: App injects and reads back its typed env
- **WHEN** an app injects its own `AppEnv` object into `vm_config`
- **THEN** the app resolves the same typed `AppEnv` from the module with no app-specific
  field defined inside `vm_config`

#### Scenario: Module stays generic to env shape
- **WHEN** the module source is inspected
- **THEN** it contains no reference to any concrete app environment field or value
