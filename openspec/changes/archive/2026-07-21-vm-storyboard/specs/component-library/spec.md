## ADDED Requirements

### Requirement: Standard component set
The module SHALL provide a reusable widget library covering: button, text input, search field, card, list item, avatar/image, app bar, chip, badge, snackbar, banner, segmented control, loading state, empty state, error state, and dialog.

#### Scenario: Consuming a component
- **WHEN** an app or another module needs one of these UI elements
- **THEN** it imports the component from `vm_storyboard`'s barrel instead of building its own

### Requirement: Components consume only standard tokens and theme
Every component SHALL read its visual values exclusively from `VmThemeTokens` and the active `ThemeData`; it MUST NOT hard-code colors, spacing, radius or font values, and MUST NOT depend on any specific app.

#### Scenario: Rendering a component in a different app
- **WHEN** the same component is rendered inside two apps with different palettes/logos registered via `vm_storyboard`
- **THEN** the component automatically reflects each app's palette without any component-level code change

### Requirement: Icons via Material Icons
Components that need an icon SHALL use Flutter's built-in Material Icons; the module SHALL NOT package a custom icon set or icon font.

#### Scenario: Component needs an icon
- **WHEN** a component (e.g. a dialog's close action) needs an icon
- **THEN** it uses an `Icons.*` constant, with no additional icon dependency introduced by the module

### Requirement: Text inputs declare a keyboard matching their purpose
Text input components SHALL set a keyboard type and input action matching what they actually collect, never the default text keyboard. A component with one fixed purpose SHALL hard-code the matching keyboard itself; a generic, reusable component SHALL expose it as a parameter for the caller to set.

#### Scenario: Purpose-built field
- **WHEN** a component has a single fixed purpose (e.g. `VmSearchField`)
- **THEN** it hard-codes the matching keyboard type and input action internally, with no parameter for the caller to get it wrong

#### Scenario: Generic field
- **WHEN** a component is generic and reusable across many purposes (e.g. `VmTextField`)
- **THEN** it exposes `keyboardType`/`textInputAction` parameters so the caller can set them to match the field's real-world purpose (email, phone, numeric, ...)
