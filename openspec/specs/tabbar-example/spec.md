## Purpose

Define the standalone `vm_tabbar` example app that demonstrates declarative tab configuration, live badges, and state preservation.

## Requirements

### Requirement: Standalone example app

`vm_tabbar` SHALL ship an `example/` app that compiles and runs the module in isolation
(with mocks where needed), configured with three mock tabs and demonstrating the module's
declarative configuration end to end.

#### Scenario: Example runs standalone

- **WHEN** the `example/` app is launched
- **THEN** it shows a bottom tab bar with three tabs, each bound to its own mock branch, with
  no dependency on any concrete app

### Requirement: Example demonstrates a live badge

The `example/` app SHALL include at least one tab with a badge whose value changes at
runtime, proving the reactive badge path.

#### Scenario: Badge changes in the example

- **WHEN** the example triggers a badge update (e.g. an incrementing counter)
- **THEN** the corresponding tab's badge updates on screen without reconfiguring the tabs

### Requirement: Example demonstrates state preservation

The `example/` app SHALL let the user produce visible state in one tab (e.g. scroll or push
a sub-route), switch tabs, and return to observe the state preserved.

#### Scenario: State preserved when alternating tabs

- **WHEN** the user changes state on tab 1, switches to tab 2, and returns to tab 1
- **THEN** tab 1's prior state is still present
