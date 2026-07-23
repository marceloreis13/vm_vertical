## Purpose

Define the offline banner widget driven by `ConnectivityCubit`, composed from `vm_storyboard` primitives, with generic pieces promoted upward.

## Requirements

### Requirement: Offline banner driven by connectivity state

The module SHALL provide an offline banner widget in its presentation layer that watches the
`ConnectivityCubit` and is visible only while the state is `Offline`. The banner SHALL be
composed from `vm_storyboard` primitives and tokens rather than ad-hoc styling. Its copy SHALL
be provided by the consumer (or a sensible default) so no app-specific text is hard-coded in
the module.

#### Scenario: Banner shows when offline

- **WHEN** the connectivity state is `Offline`
- **THEN** the banner SHALL be visible

#### Scenario: Banner hides when online

- **WHEN** the connectivity state transitions to `Online`
- **THEN** the banner SHALL be hidden

### Requirement: Generic pieces promoted to vm_storyboard

Any genuinely generic UI piece needed by the banner that is missing from the design system
SHALL be promoted to `vm_storyboard` rather than built locally. Connectivity-specific
composition SHALL remain in `vm_connectivity`.

#### Scenario: Missing generic primitive is promoted

- **WHEN** the banner needs a generic primitive absent from `vm_storyboard`
- **THEN** that primitive SHALL be added to `vm_storyboard` and consumed by the banner, keeping only connectivity-specific wiring local
