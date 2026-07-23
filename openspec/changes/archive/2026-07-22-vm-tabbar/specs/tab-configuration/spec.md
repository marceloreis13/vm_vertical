## ADDED Requirements

### Requirement: Declarative injected tab configuration

`vm_tabbar` SHALL expose a `VmTab` value object carrying an icon, a label, the branch its
content lives in (branch index/reference into the shell's `VmBranch` list), and an optional
badge source. The consuming app SHALL supply an ordered `List<VmTab>` and the matching
branch route lists. `vm_tabbar` SHALL NOT reference any concrete screen and SHALL NOT
import a design-system package.

#### Scenario: App configures its own tabs

- **WHEN** an app supplies `[VmTab(home), VmTab(search), VmTab(profile)]` with three
  branches
- **THEN** the tab shell renders three tabs bound to those branches, and `vm_tabbar` code
  contains no reference to the app's concrete screens

#### Scenario: Different apps configure different tabs without module changes

- **WHEN** two apps supply different `List<VmTab>` and branch lists
- **THEN** each renders its own tabs using the same unmodified `vm_tabbar` module

### Requirement: Injected style tokens

`vm_tabbar` SHALL render the bar exclusively from an injected `VmTabBarStyle` (colors,
icon/label styles, badge style, elevation, height). It SHALL NOT depend on `vm_storyboard`;
the app maps its theme into `VmTabBarStyle`. A sensible default `VmTabBarStyle` derivable
from `ThemeData` SHALL be provided so the module runs standalone without storyboard wiring.

#### Scenario: Bar styled from injected tokens

- **WHEN** an app injects a `VmTabBarStyle`
- **THEN** the bar's colors, typography, badge, elevation, and height reflect the injected
  tokens, with no compile-time dependency on `vm_storyboard`

#### Scenario: Default style without injection

- **WHEN** no `VmTabBarStyle` is supplied
- **THEN** the bar renders using a default derived from the ambient `ThemeData`

### Requirement: Single injected registration entry point

`vm_tabbar` SHALL expose one registration function that receives a `VmTabbarConfig` (the tab
list and style) from the consuming app via GetIt + Injectable. No app-specific value SHALL
be hard-coded inside the module.

#### Scenario: App registers the module with its config

- **WHEN** the app calls the module's registration function with its `VmTabbarConfig`
- **THEN** the tab shell and `VmTabBarCubit` resolve from DI configured with that app's tabs
  and style
