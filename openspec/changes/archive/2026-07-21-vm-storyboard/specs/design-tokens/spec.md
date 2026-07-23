## ADDED Requirements

### Requirement: Unified design tokens extension
The module SHALL expose all fixed design tokens (spacing, radius, elevation, animation duration, typography scale) through a single `ThemeExtension` (`VmThemeTokens`).

#### Scenario: Consuming tokens from a component
- **WHEN** a component inside `vm_storyboard` needs a spacing, radius, elevation or duration value
- **THEN** it reads it from `Theme.of(context).extension<VmThemeTokens>()`, never from a hard-coded literal

### Requirement: Tokens are fixed across apps
Spacing, radius, elevation and animation duration values SHALL be identical for every app that consumes the module; they are not part of the app-customizable subset.

#### Scenario: Two apps register the module
- **WHEN** two different apps register `vm_storyboard` with different color palettes
- **THEN** both apps render components with the same spacing, radius, elevation and animation duration values

### Requirement: Default visual language is spacious, softly-elevated, fluid and expressive
The default token values in `VmThemeTokens` SHALL express a consistent visual language across every app: generous spacing, rounded corners on surface components, soft/diffused elevation with no glass or blur effects, fluid motion with slower and smooth easing curves, and an expressive typographic hierarchy with headings clearly distinct from body text.

#### Scenario: Default values across all apps
- **WHEN** any app registers `vm_storyboard` without altering the fixed tokens
- **THEN** its spacing, corner radius, elevation, motion and typography follow this same spacious, softly-elevated, fluid and expressive visual language

#### Scenario: App wants a different visual flavor
- **WHEN** an app wants a visually distinct flavor (for example a different elevation or motion style)
- **THEN** it can only achieve that through its color palette, logo or content imagery, not by overriding spacing, radius, elevation or motion tokens

### Requirement: Typography scale is a fixed token
The typographic scale (text styles, sizes, weights, line heights) SHALL be part of `VmThemeTokens` and SHALL NOT vary by app; only the font family may vary (see `theming`).

#### Scenario: Reading a text style
- **WHEN** a component needs a heading or body text style
- **THEN** it reads size/weight/line-height from `VmThemeTokens`, and the font family from the active `ThemeData`
