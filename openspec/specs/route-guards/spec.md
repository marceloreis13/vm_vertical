# route-guards

## Purpose

Defines the generic, injectable guard contract used to gate routes in
`vm_navigation` — a predicate (sync or async) usable for any condition (auth,
feature flags, or otherwise), with no dependency on `vm_auth` or `vm_config`, and
support for attaching multiple guards to a single route.

## Requirements

### Requirement: Generic injectable guard contract

The module SHALL expose a single generic guard contract (a predicate, sync or async,
returning a boolean or `Result`) usable to gate any route, regardless of what the guard
checks (auth state, feature flags, or any other condition). The module SHALL NOT
depend on `vm_auth` or `vm_config`; the concrete guard logic is supplied by the
consuming app.

#### Scenario: App injects an auth-like guard

- **WHEN** an app registers a route with a guard predicate that reads an in-memory or
  externally-supplied logged-in flag
- **THEN** the route resolves normally when the predicate returns true and is blocked
  (subject to redirect, see `conditional-redirect`) when it returns false

#### Scenario: App injects a feature-flag-like guard

- **WHEN** an app registers a route with a guard predicate that reads a boolean flag
  unrelated to authentication
- **THEN** the same guard contract and resolution mechanism apply, with no
  auth-specific code path required

#### Scenario: Guard contract has no auth/config dependency

- **WHEN** `vm_navigation` is compiled standalone (via its `example/`)
- **THEN** it does not import or depend on `vm_auth` or `vm_config` in any form

### Requirement: Multiple guards per route

The module SHALL support attaching more than one guard predicate to a single route.

#### Scenario: Route with two guards

- **WHEN** a route is registered with two guard predicates and one returns false
- **THEN** the route is treated as blocked (guards combine as a logical AND)
