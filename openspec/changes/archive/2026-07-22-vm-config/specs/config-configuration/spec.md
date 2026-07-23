## ADDED Requirements

### Requirement: Injected VmConfigConfig
The module SHALL define a `VmConfigConfig` value carrying the remote `RemoteConfigProvider`,
the local defaults map, the active `VmEnvironment`, the app-injected env object, and an
optional `ConfigCache`. No source, key, or app-specific value SHALL be hard-coded inside the
module; everything the module needs SHALL arrive through `VmConfigConfig`.

#### Scenario: App supplies configuration at startup
- **WHEN** an app builds a `VmConfigConfig` with its provider, defaults, environment and env
  object
- **THEN** the module operates entirely from that config with nothing hard-coded

#### Scenario: Cache is optional in config
- **WHEN** `VmConfigConfig` omits a `ConfigCache`
- **THEN** the module registers and runs without any cache

### Requirement: Single DI registration entry point
The module SHALL expose exactly one Injectable registration function (e.g.
`registerVmConfigModule`) that receives `VmConfigConfig` and registers the `ConfigReader`,
the provider, the resolution engine and (if present) the cache into GetIt. Consumers SHALL
depend only on barrel-exported types.

#### Scenario: One call wires the module
- **WHEN** the app calls the single registration function with its `VmConfigConfig`
- **THEN** `ConfigReader` and the environment accessor are resolvable from GetIt

#### Scenario: Public surface is barrel-only
- **WHEN** a consumer imports the module
- **THEN** it imports only `package:vm_config/vm_config.dart` and reaches nothing under
  `lib/src/`

### Requirement: Standalone visual example
The module SHALL ship a standalone `example/` app built with `vm_storyboard` that uses a
local/static-map provider to toggle flags and values and reflects them live in the UI,
demonstrating the observable change stream and the remote > cache > default precedence.
Generic UI components missing from the design system SHALL be promoted to `vm_storyboard`.

#### Scenario: Toggling a flag updates the UI live
- **WHEN** the example toggles a flag in its local provider and refreshes
- **THEN** the on-screen value updates via the observable change stream without a restart

#### Scenario: Example runs with no real vendor SDK
- **WHEN** the example is launched
- **THEN** it runs entirely on the built-in providers with no external remote source
