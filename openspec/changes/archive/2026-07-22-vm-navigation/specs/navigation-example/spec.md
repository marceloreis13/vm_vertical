## ADDED Requirements

### Requirement: Standalone runnable example

The module SHALL ship a standalone `example/` app, compiling and running independently
of any consuming app, demonstrating route registration, guards, redirect, and the
navigator service end to end.

#### Scenario: Example compiles and runs standalone

- **WHEN** the `example/` app is run on its own (no external app dependency)
- **THEN** it builds and runs, exercising `vm_navigation`'s full public API

### Requirement: Three-screen guard and navigation demo

The example SHALL contain three screens: one with a local in-memory logged-in/out
toggle (no `vm_auth` dependency), one protected route that redirects to another screen
when the guard fails, and one that triggers navigation from a Cubit via the navigator
service.

#### Scenario: Toggle changes guard outcome

- **WHEN** the user flips the in-memory logged-in/out toggle and then navigates to the
  protected route
- **THEN** the route resolves or redirects according to the current toggle state

#### Scenario: Cubit-driven navigation is demonstrated

- **WHEN** the user triggers the action wired to the example's Cubit
- **THEN** the Cubit calls the navigator service directly (no `BuildContext`) and the
  expected screen is shown

### Requirement: Optional vm_storyboard integration in the example

The example SHALL use `vm_storyboard` for transitions/theme where applicable, without
`vm_navigation` itself requiring `vm_storyboard` as a hard dependency.

#### Scenario: Example uses storyboard transitions

- **WHEN** the example navigates between screens
- **THEN** transitions/theme are sourced from `vm_storyboard` tokens/widgets already
  present in the monorepo
