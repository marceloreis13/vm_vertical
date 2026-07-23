## Purpose

Define the source-agnostic `ConfigReader` interface: synchronous typed getters that never fail, an observable change stream, and a typed failure taxonomy scoped to refresh/fetch paths.

## Requirements

### Requirement: Source-agnostic config reader
The module SHALL expose a `ConfigReader` interface as the only type consumers depend on to
read configuration. No remote source, cache, or vendor SDK type SHALL appear in its public
API. `ConfigReader` SHALL be resolvable from DI and injectable into any module or app.

#### Scenario: Consumer reads without knowing the source
- **WHEN** a module resolves `ConfigReader` and reads a flag
- **THEN** it obtains a value without importing or referencing any remote provider, cache,
  or `vm_storage` type

### Requirement: Synchronous typed getters with inline defaults
`ConfigReader` SHALL provide synchronous typed getters `getBool`, `getInt`, `getDouble`,
`getString` and `getJson`, each taking a key and an inline default value. A getter SHALL
return the resolved value for its key, or the supplied default when the key is unresolved.
A getter SHALL be non-blocking and SHALL NOT return a `Future` or `Result`.

#### Scenario: Known key returns its resolved value
- **WHEN** `getBool('new_checkout', false)` is called and the key resolves to `true`
- **THEN** it returns `true` synchronously

#### Scenario: Unknown key returns the inline default
- **WHEN** `getString('theme', 'light')` is called and no source provides `theme`
- **THEN** it returns `'light'` synchronously

#### Scenario: JSON value is returned decoded
- **WHEN** `getJson('layout', {})` is called and the key resolves to a JSON object
- **THEN** it returns that object as a `Map<String, dynamic>`

### Requirement: Reads never fail
A read through `ConfigReader` SHALL never throw and SHALL never surface a `ConfigFailure` to
the caller. A remote-source failure, a missing key, or a type mismatch SHALL resolve to the
next value in precedence, ultimately the inline default.

#### Scenario: Type mismatch falls back to default
- **WHEN** `getInt('count', 10)` is called but the resolved raw value cannot be read as an
  int
- **THEN** it returns `10` and does not throw

#### Scenario: Remote failure does not reach a read
- **WHEN** the remote provider has failed to fetch and a getter is called
- **THEN** the getter returns the cache or default value without throwing

### Requirement: Observable config changes
`ConfigReader` SHALL expose a broadcast `changes` stream that emits the set of keys whose
resolved value changed, and a `valueStream<T>(key, default)` that emits the current resolved
value for a key and re-emits when it changes. Emissions SHALL occur after a resolution
recompute (e.g. following a successful `refresh()`), and only for keys whose resolved value
actually changed.

#### Scenario: Flag flip notifies observers
- **WHEN** a refresh changes `new_checkout` from `false` to `true`
- **THEN** the `changes` stream emits an event including `new_checkout` and
  `valueStream('new_checkout', false)` emits `true`

#### Scenario: Unchanged keys do not emit
- **WHEN** a refresh leaves `theme` at its previous resolved value
- **THEN** no change event is emitted for `theme`

### Requirement: Typed ConfigFailure taxonomy
The module SHALL define a sealed `ConfigFailure` taxonomy locally in `lib/src/`, covering at
least remote-fetch and cache-access failures, isolated so a future `vm_foundation` migration
is a re-home. `ConfigFailure` SHALL only surface on `refresh()`/fetch paths, never on reads.

#### Scenario: Failure is typed, not a raw exception
- **WHEN** a remote fetch fails
- **THEN** the failure is represented as a `ConfigFailure` variant, not a raw exception
