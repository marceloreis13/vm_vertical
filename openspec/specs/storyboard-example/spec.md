## Purpose

Defines the `example/` gallery/catalog app that ships with `vm_storyboard`: a standalone
storybook covering every component in both themes, the golden-test baseline, and a live demo
of how an app customizes the module's theme.

## Requirements

### Requirement: Standalone gallery example
The module's `example/` SHALL be a standalone gallery/catalog app that renders every component in the library, compiling and running without any app under `apps/`.

#### Scenario: Building the example standalone
- **WHEN** a developer runs `example/` on its own
- **THEN** it compiles and displays every component from the component library

### Requirement: Gallery covers both themes with a mock palette
The gallery SHALL render its components using one mock `VmColorPalette` and SHALL support switching between the light and dark theme.

#### Scenario: Switching theme in the gallery
- **WHEN** a developer toggles the theme in the gallery
- **THEN** all components re-render using the same mock palette under the newly selected theme (light or dark)

### Requirement: Gallery is the golden test baseline
Golden tests for components and themes SHALL be captured from the gallery's screens, covering both the light and dark theme with the gallery's mock palette.

#### Scenario: Running golden tests
- **WHEN** the module's golden test suite runs
- **THEN** it renders the gallery screens under both themes and compares them against the committed golden baseline

### Requirement: Example demonstrates live palette switching
The `example/` app SHALL let a developer switch between multiple `VmColorPalette`s at runtime, showing in code how an app changes the module's theme without touching any component.

#### Scenario: Switching palette in the example
- **WHEN** a developer picks a different palette from the example app's palette switcher
- **THEN** the app's theme is rebuilt from that palette using the module's public theme-building function, and every visible component reflects the new colors with no component-level change
