## Context

`vm_core` is a modular Flutter monorepo ("Lego board"): apps compose reusable `vm_*`
packages on demand. Base (Propose 1) established the conventions — Clean Architecture +
feature-first, barrel-only public API, DI via GetIt + Injectable with config injected by the
consuming app, and a standalone runnable `example/` per module. `vm_navigation`, `vm_network`,
`vm_storage`, `vm_localization`, and `vm_storyboard` already exist; `vm_analytics` and
`vm_logging` are in flight.

`vm_config` is an infrastructure module: a single, injectable source of configuration —
typed environment, feature flags, and remote config — so behaviour and whole modules can be
toggled without a deploy. Apps inject the remote provider, the environment, and the local
defaults; modules read through one interface without knowing the source. The architecture
memory earmarks `Result`/`Failure`/`VMModule` for a future `vm_foundation`; `vm_config`
defines a local `ConfigFailure` for the fetch/refresh path only.

Constraints: barrel-only public surface (no source/vendor type leaks); config never
hard-coded; remote failures isolated so reads never break; reads non-blocking for callers;
no hard dependency on `vm_storage`.

## Goals / Non-Goals

**Goals:**
- One `ConfigReader` interface consumed by 2+ modules/apps; swapping the remote source never
  changes a read call site.
- Synchronous typed reads (`getBool`/`getInt`/`getDouble`/`getString`/`getJson`) with inline
  defaults that always resolve by precedence **remote > cache > default** and never fail.
- An observable change stream so modules react to flag flips at runtime.
- A pull-based `RemoteConfigProvider` port with isolated fetch failures and a `refresh()`
  that returns `Result<Unit, ConfigFailure>`.
- A `VmEnvironment` enum plus a generic holder for an app-defined, app-injected typed env
  object.
- An injectable `ConfigCache` seam with no pubspec dependency on `vm_storage`.
- Built-in `local` and observable `static-map` providers; a visual `example/` that toggles
  flags and reflects them live with no real vendor SDK.

**Non-Goals:**
- Concrete remote sources (Firebase Remote Config, LaunchDarkly, …) — apps implement
  `RemoteConfigProvider`.
- A flag/config admin console.
- Realtime/push updates from a provider (pull-based now; push is a later optional seam).
- Consent/experimentation/A-B assignment logic.
- A full `vm_logging` integration (later change); logging uses `dart:developer` via a seam.

## Decisions

### `ConfigReader` interface + `RemoteConfigProvider` port (source behind a seam)
The public `ConfigReader` (typed getters, environment accessor, `changes`/`valueStream`,
`refresh()`) is the only type consumers depend on. A pull-based `RemoteConfigProvider` port
declares `fetch()`; the reader's job is resolution + observation, the provider's job is SDK
translation. *Alternative:* let consumers hold the provider directly — rejected; it leaks the
source and precedence into call sites.

### Synchronous typed getters with inline defaults, never failing
Reads are `getBool(key, default)` etc., synchronous and total: a value always resolves by
remote > cache > default, and a missing key or type mismatch collapses to the default. This
matches how flags are consumed (call sites branch on a value, not on a fetch outcome) and
keeps a bad remote payload from crashing a screen. *Alternatives:* async `Result<T>` reads
like `vm_storage` — rejected, it would force error handling at every flag site; a raw
`get(String)` returning `dynamic` — rejected, it pushes casting/defaulting to callers.

### `refresh()` returns `Result`, reads do not
Only `refresh()`/fetch surfaces `Result<Unit, ConfigFailure>`; a failed fetch is caught,
reported via the logging seam, and leaves the last good snapshot intact. This concentrates
error handling at the one place that can meaningfully act on it (retry/telemetry) and keeps
the read path total. *Alternative:* fire-and-forget refresh like `vm_analytics` tracking —
rejected; callers legitimately want to know whether a fetch succeeded, and the module can
still keep serving old values regardless.

### Resolution engine with precedence remote > cache > default + change diffing
A single engine holds the resolved snapshot, layering remote over cache over defaults, and on
each recompute diffs against the previous snapshot to emit change events for only the keys
that changed. This centralises precedence (a success criterion) and makes the observable
stream exact. *Alternative:* compute precedence lazily per getter with no snapshot — rejected;
it makes change detection and "only changed keys emit" hard and repeats work per read.

### Injectable `ConfigCache` seam, no `vm_storage` dependency
Caching is a `ConfigCache` port the app optionally wires (e.g. over `vm_storage`'s
`DocumentStore`/`KeyValueStore`). The module never imports `vm_storage`; with no cache,
precedence is remote > default. This honours the brief's "opcional: vm_storage" and keeps a
minimal app from pulling storage weight it does not use. *Alternative:* a hard `vm_storage`
dependency like `vm_analytics`→`vm_navigation` — rejected here; the brief explicitly marks
storage optional and caching is not the headline feature.

### `VmEnvironment` enum + generic app env holder
The module owns a `VmEnvironment` enum (dev/staging/prod) but treats the app's typed env
object as an opaque injected value, exposed back unchanged. The module declares no
app-specific field, staying generic. *Alternative:* the module reads `--dart-define`/`.env`
into a typed struct — rejected; those fields are app-specific and would either hard-code app
concerns into the module or force an untyped map, both worse than the app owning its env type.

### Built-in `local` + observable `static-map` providers
`local` contributes no remote values (serves defaults/cache) and is the inert default for
tests/standalone. `static-map` wraps a mutable in-memory map and, on `refresh()`, updates
resolved values and emits changes, so the `example/` can toggle flags live and demonstrate
the seam. *Alternative:* have the example subclass a provider itself — rejected; a reusable
observable provider demonstrates the real seam and doubles as a test double.

## Risks / Trade-offs

- **Synchronous reads require an already-resolved snapshot** → the module resolves defaults
  (and cache, if present) synchronously at registration so getters are valid before the first
  remote fetch; `refresh()` later overlays remote values and emits changes.
- **No hard cache means cold start serves defaults until first fetch** → mitigated by the
  optional `ConfigCache` seam persisting the last snapshot, so apps that wire it survive
  restarts with the last known remote values.
- **Fire-and-forget-style isolation hides fetch failures from reads** → mitigated by
  `refresh()` returning a typed `Result` and by routing isolated failures through the logging
  seam (later `vm_logging`).
- **Pull-based only, no realtime** → out of scope now; a provider can expose a stream later
  behind an optional seam that simply triggers `refresh()`, with no change to `ConfigReader`.
- **Type mismatch silently falls back to default** → accepted for read totality; the debug
  seam logs mismatches so misconfigured remote payloads are diagnosable in dev.
- **`vm_logging` does not exist yet** → the debug/error seam uses `dart:developer`, isolated
  so the later swap to `vm_logging` is a re-home, mirroring `vm_network`/`vm_analytics`.

## Migration Plan

New additive module; no existing behaviour changes. Add `packages/vm_config` to the root
`workspace:`, implement the capabilities, ship `example/`, register the module in `docs/`.
Rollback is removal of the package and its workspace entry. Concrete remote sources are
adopted later by implementing `RemoteConfigProvider` (and, for persistence, `ConfigCache`
over `vm_storage`) in the app, with no change to `vm_config`.

## Open Questions

- None blocking. Realtime/push provider updates, consent/experimentation, and the
  `vm_logging` swap are deferred to future changes.
