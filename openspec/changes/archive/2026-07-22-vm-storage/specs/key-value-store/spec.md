## ADDED Requirements

### Requirement: Key-value persistence API

The module SHALL expose a `KeyValueStore` interface for string-keyed persistence of light
values (preferences and flags), hiding the concrete backend. The API SHALL provide
`set`, `get`, `remove`, `containsKey`, and `clear`, and SHALL support at least string,
bool, int, double, and string-list values. Consumers SHALL NOT reference the backend
package directly.

#### Scenario: Write then read a value

- **WHEN** a consumer calls `set('theme', 'dark')` and later `get<String>('theme')`
- **THEN** the store returns `Result` success with `'dark'`

#### Scenario: Read a missing key

- **WHEN** a consumer calls `get` for a key that was never set
- **THEN** the store returns a not-found `StorageFailure`, never a raw exception

#### Scenario: Remove and check presence

- **WHEN** a consumer calls `remove('theme')` and then `containsKey('theme')`
- **THEN** `containsKey` returns success with `false`

#### Scenario: Delete is physical

- **WHEN** a consumer calls `remove` on a key
- **THEN** the value is physically removed with no tombstone retained

### Requirement: shared_preferences reference backend

The module SHALL provide a `KeyValueStore` implementation backed by `shared_preferences`,
registered only when the app opts into it. The backend detail SHALL NOT leak through the
package barrel.

#### Scenario: Backend swap is invisible to consumers

- **WHEN** the registered `KeyValueStore` implementation is replaced by another backend
  honoring the same interface
- **THEN** consuming code compiles and behaves unchanged
