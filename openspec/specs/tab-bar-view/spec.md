## Purpose

Define the `VmTabBar` widget: rendering tabs and active state, badges, and styling from injected tokens with golden coverage.

## Requirements

### Requirement: Bottom bar renders tabs and active state

`vm_tabbar` SHALL provide a `VmTabBar` widget that renders one item per `VmTab` (icon +
label) in configured order and visually distinguishes the active tab from the emitted
`VmTabBarState.index`. Tapping an item SHALL invoke tab selection.

#### Scenario: Active tab is highlighted

- **WHEN** `VmTabBarState.index` is 1
- **THEN** the second item is rendered in its active style and the others in their inactive
  style

#### Scenario: Tapping an item requests selection

- **WHEN** the user taps the third item
- **THEN** `VmTabBarCubit.select(2)` is invoked

### Requirement: Badges rendered on tabs

`VmTabBar` SHALL render a badge on an item when its tab has a current badge value (count or
dot), styled from the injected `VmTabBarStyle`, and render none when the badge value is
absent.

#### Scenario: Count badge shown

- **WHEN** tab 0's badge value is a count of 3
- **THEN** the first item displays a "3" badge in the injected badge style

#### Scenario: No badge when absent

- **WHEN** a tab has no current badge value
- **THEN** its item shows no badge

### Requirement: Styling from injected tokens with golden coverage

`VmTabBar` SHALL derive all colors, typography, badge appearance, elevation, and height
from the injected `VmTabBarStyle`, and its rendering SHALL be covered by a golden test of
the bar in isolation.

#### Scenario: Golden of the bar

- **WHEN** the golden test renders `VmTabBar` with a fixed style, tab list, active index,
  and a badge
- **THEN** the output matches the committed golden image
