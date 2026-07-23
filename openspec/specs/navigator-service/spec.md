# navigator-service

## Purpose

Defines the injectable, context-free navigation service exposed by `vm_navigation`:
`push`, `pop`, `replace`, and `go` operations over typed routes, backed by a single
root navigator registered once during module setup.

## Requirements

### Requirement: Context-free navigation service

The module SHALL expose an injectable (GetIt-registered) navigator service providing
`push`, `pop`, `replace`, and `go` operations that accept typed routes, callable without
a `BuildContext`.

#### Scenario: Cubit navigates without BuildContext

- **WHEN** a Cubit resolves the navigator service via GetIt and calls `go`/`push` with a
  typed route
- **THEN** navigation occurs correctly without the Cubit holding or receiving a
  `BuildContext`

#### Scenario: All four operations are available

- **WHEN** consuming code calls `push`, `pop`, `replace`, or `go` on the service
- **THEN** each operation performs the corresponding `go_router` navigation behavior

### Requirement: Single root navigator by default

The module SHALL back the navigator service with a single root
`GlobalKey<NavigatorState>` (or the root `StatefulNavigationShell` where present),
registered once during module setup.

#### Scenario: Service resolves the current router

- **WHEN** the navigator service is invoked after the app's `GoRouter` has been built
  with the registered key
- **THEN** the service correctly resolves and drives that `GoRouter` instance
