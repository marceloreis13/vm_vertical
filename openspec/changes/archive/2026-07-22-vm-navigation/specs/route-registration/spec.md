## ADDED Requirements

### Requirement: Typed per-module route lists

The module SHALL define a route type/API such that each module/feature exposes its
routes as a `List<RouteBase>` (built from typed route definitions with typed path
parameters), without referencing any other module's routes or the app's router
instance.

#### Scenario: Module exposes its own routes

- **WHEN** a feature module declares its routes via the module's route-list contract
- **THEN** the returned value is a `List<RouteBase>` usable directly by `go_router`,
  with no compile-time or runtime reference to another module's route classes

### Requirement: App-side route aggregation

The app SHALL be able to build a single `GoRouter` by concatenating the `List<RouteBase>`
from every module it has activated, with no module aware of which other modules are
present.

#### Scenario: N modules aggregate without coupling

- **WHEN** an app activates modules A and B, each exposing its own route list, and
  concatenates both lists into one `GoRouter`
- **THEN** routes from both modules resolve correctly, and neither module's code
  imports or references the other module's routes

#### Scenario: Removing a module removes only its routes

- **WHEN** an app stops activating a previously-included module
- **THEN** only that module's routes disappear from the aggregated `GoRouter`; routes
  from remaining modules are unaffected
