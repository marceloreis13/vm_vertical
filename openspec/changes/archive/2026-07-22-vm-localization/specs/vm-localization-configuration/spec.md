## ADDED Requirements

### Requirement: Injected configuration
The module SHALL define a `VmLocalizationConfig` supplied by the consuming app, carrying the list of supported locales, the default locale, and whether persistence is backed by `vm_storage`. The module SHALL NOT hard-code supported locales, the default locale, or read global/ambient state.

#### Scenario: Config provided at registration
- **WHEN** the app registers the module with a `VmLocalizationConfig`
- **THEN** the module resolves its supported locales and default locale using only that config

#### Scenario: No hard-coded locale list
- **WHEN** the module source is inspected
- **THEN** it SHALL contain no hard-coded supported-locale list or default locale

### Requirement: Single DI registration entry point
The module SHALL expose one registration function in its barrel (GetIt + Injectable) that receives `VmLocalizationConfig`. It SHALL register `LocaleRepository` selectively: an in-memory implementation by default, or a `vm_storage`-backed implementation when the app opts into persistence via config.

#### Scenario: Registering without persistence
- **WHEN** the app registers the module without opting into `vm_storage`-backed persistence
- **THEN** the module registers the in-memory `LocaleRepository` implementation

#### Scenario: Registering with vm_storage-backed persistence
- **WHEN** the app registers the module with persistence enabled in config
- **THEN** the module registers a `LocaleRepository` implementation backed by `vm_storage`'s `KeyValueStore`

### Requirement: LocaleRepository domain interface
The domain layer SHALL define a `LocaleRepository` interface with operations to read the previously saved locale and to save a chosen locale, each returning a typed `Result`. No implementation detail of the backing store SHALL leak through this interface.

#### Scenario: Reading with nothing saved yet
- **WHEN** `LocaleRepository.getSaved()` is called and no locale was ever saved
- **THEN** it returns a successful `Result` with no locale (not an error)

#### Scenario: Saving a locale
- **WHEN** `LocaleRepository.save(locale)` is called
- **THEN** subsequent calls to `getSaved()` return that locale
