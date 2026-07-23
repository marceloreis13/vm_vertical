## ADDED Requirements

### Requirement: Light and dark ThemeData derived from tokens
The module SHALL derive a light and a dark `ThemeData` from `VmThemeTokens` and the app-injected `VmThemeConfig`.

#### Scenario: App registers the module
- **WHEN** an app calls the module's registration function with a `VmThemeConfig`
- **THEN** the module produces both a light and a dark `ThemeData`, consistent with the injected palette and the fixed tokens

### Requirement: Registration via GetIt
The module SHALL expose a single registration function that registers `VmThemeConfig`, `VmThemeTokens`, and a `VmTheme` wrapper (holding the light and dark `ThemeData`) as singletons in the app's `GetIt` instance.

#### Scenario: Resolving the theme after registration
- **WHEN** an app has called the registration function
- **THEN** it can resolve `VmTheme` from `GetIt` and use its `light`/`dark` `ThemeData` when configuring `MaterialApp`

#### Scenario: Resolving config or tokens outside the widget tree
- **WHEN** code with no `BuildContext` (for example a Cubit or a use case) needs the injected `VmThemeConfig` or the fixed `VmThemeTokens`
- **THEN** it resolves them from `GetIt`, without needing a `BuildContext`

### Requirement: App-customizable subset
Each app SHALL be able to customize exactly three things: color palette, logo, and (optionally) font family. All other tokens (spacing, radius, elevation, component behavior) remain fixed.

#### Scenario: App overrides palette and logo
- **WHEN** an app provides its own `VmColorPalette` and `VmLogo`
- **THEN** the resulting theme uses that palette and logo, while spacing, radius, elevation and component behavior stay identical to any other app using the module

### Requirement: Color palette and logo are required
An app registering the module MUST supply a color palette and a logo. The module SHALL NOT provide a default palette or a default logo asset.

#### Scenario: Registration without a logo
- **WHEN** an app calls the registration function without providing a logo
- **THEN** registration fails with an explicit configuration error, instead of silently rendering a placeholder

### Requirement: Font family has a packaged default with optional override
The module SHALL package a default font family, used when the app does not specify one. An app MAY override the font family via `VmThemeConfig.fontFamily`.

#### Scenario: App does not specify a font
- **WHEN** an app registers the module without setting `fontFamily`
- **THEN** the resulting theme uses the module's packaged default font family

#### Scenario: App specifies a font
- **WHEN** an app sets `fontFamily` in `VmThemeConfig`
- **THEN** the resulting theme uses that font family instead of the default

### Requirement: Apps may extend with their own tokens
The module SHALL allow an app to register additional `ThemeExtension`s of its own alongside `VmThemeTokens`, without altering the module's fixed tokens.

#### Scenario: App adds a custom extension
- **WHEN** an app registers an additional `ThemeExtension` for a token it owns
- **THEN** the app's extension is available via `Theme.of(context)` alongside `VmThemeTokens`, and `VmThemeTokens` itself is unchanged
