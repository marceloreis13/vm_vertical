## ADDED Requirements

### Requirement: Precedence remote > cache > default
The resolution engine SHALL resolve every key by the precedence **remote > cache >
default**. A value present in the latest successful remote snapshot SHALL win; absent that,
a cached value SHALL win; absent that, the injected local default (or the getter's inline
default) SHALL be used.

#### Scenario: Remote overrides cache and default
- **WHEN** a key exists in the remote snapshot, in cache, and in defaults with different
  values
- **THEN** the resolved value is the remote one

#### Scenario: Cache used when remote lacks the key
- **WHEN** a key is absent from the remote snapshot but present in cache
- **THEN** the resolved value is the cached one

#### Scenario: Default used when neither remote nor cache has the key
- **WHEN** a key is absent from both remote and cache
- **THEN** the resolved value is the default

### Requirement: Injectable cache seam
The module SHALL define a `ConfigCache` port for persisting and reading back the last remote
snapshot. The module SHALL NOT depend on `vm_storage` in its pubspec; an app MAY inject a
`ConfigCache` implementation (e.g. backed by `vm_storage`). When no cache is injected,
precedence SHALL collapse to remote > default and no persistence occurs.

#### Scenario: Cache seam persists the last snapshot
- **WHEN** a `ConfigCache` is injected and a refresh succeeds
- **THEN** the module writes the new snapshot to the cache through the port

#### Scenario: No cache wired still works
- **WHEN** no `ConfigCache` is injected
- **THEN** the module resolves values with remote > default and performs no cache access

#### Scenario: Cached snapshot survives restart
- **WHEN** a cache holds a snapshot and the module initialises before any remote fetch
  completes
- **THEN** reads resolve from the cached snapshot rather than falling straight to defaults

### Requirement: Change detection feeds the observable stream
On each resolution recompute the engine SHALL diff the new resolved snapshot against the
previous one and emit change events only for keys whose resolved value changed. A cache
access or remote-fetch failure SHALL NOT emit spurious change events.

#### Scenario: Only changed keys are emitted
- **WHEN** a recompute changes two keys and leaves the rest unchanged
- **THEN** exactly those two keys are emitted as changes

#### Scenario: Failed refresh emits nothing
- **WHEN** a refresh fails and the resolved snapshot is unchanged
- **THEN** no change events are emitted
