# locale-switching

## Purpose
`vm_localization` owns the app's active locale as observable state: a Cubit resolves
the initial locale at startup (persisted choice, or config default) and exposes an
operation to change it at runtime, so the consuming app's root widget can bind
`MaterialApp.locale` to it and have every module's own generated localizations update
together.

## Requirements

### Requirement: Active locale state
The module SHALL expose a Cubit that holds the active locale and the configured list of supported locales, resolved at startup from the persisted locale (if any and if still supported) or otherwise from `VmLocalizationConfig.defaultLocale`.

#### Scenario: Startup with a valid saved locale
- **WHEN** the Cubit starts and a previously saved locale is present in the supported-locales list
- **THEN** the initial state's locale is the saved locale

#### Scenario: Startup with no saved locale
- **WHEN** the Cubit starts and no locale was previously saved
- **THEN** the initial state's locale is `VmLocalizationConfig.defaultLocale`

#### Scenario: Startup with a saved locale no longer supported
- **WHEN** the Cubit starts and the saved locale is not in the current supported-locales list
- **THEN** the initial state's locale falls back to `VmLocalizationConfig.defaultLocale`

### Requirement: Runtime locale change
The module SHALL expose an operation to change the active locale at runtime. The operation SHALL reject a locale not present in the supported-locales list, and SHALL persist a successful change through `LocaleRepository`.

#### Scenario: Changing to a supported locale
- **WHEN** the app requests a change to a locale present in the supported-locales list
- **THEN** the Cubit emits a new state with that locale and persists it via `LocaleRepository`

#### Scenario: Rejecting an unsupported locale
- **WHEN** the app requests a change to a locale absent from the supported-locales list
- **THEN** the Cubit SHALL NOT emit a new state and SHALL NOT persist anything

### Requirement: App-wide reflection of a locale change
Changing the active locale SHALL be observable by the consuming app's root widget, so that binding `MaterialApp.locale` to this state is sufficient for every module's own `Localizations`-resolved text (via each module's independently generated delegate) to update, without `vm_localization` addressing any other module directly.

#### Scenario: MaterialApp rebuilds on locale change
- **WHEN** the active locale changes and the app's `MaterialApp` observes this Cubit's state for its `locale` property
- **THEN** the widget tree rebuilds under the new locale, and every mounted module's own generated localizations resolve text for that locale
