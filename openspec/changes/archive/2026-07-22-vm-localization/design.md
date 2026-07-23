## Context

`vm_core` is a modular Flutter monorepo (Pub Workspace) where `apps/*` compose
`packages/vm_*` modules on demand, each standalone (own `example/`), each injected with
config by the consuming app (no ambient/global state), each exposing only a barrel
(`lib/<pkg>.dart`). No `vm_foundation` package exists yet — modules that need shared
core types (`Result`, sealed failures) define them locally under `lib/src/core/`,
isolated so a future `vm_foundation` migration is a re-home, not a rewrite
(established by `vm_storage`).

`vm_localization` is a standalone module like any other: no other module depends on it,
and it does not reach into another module's presentation layer. It depends on
`vm_storage` only optionally, for persisting the chosen locale.

## Goals / Non-Goals

**Goals:**
- Runtime locale switching, held centrally and observed by the app's `MaterialApp`.
- Locale-aware date/number/currency formatting via `intl`.
- Locale persistence that degrades gracefully when `vm_storage` isn't wired in.
- A standalone example proving the mechanism entirely within `vm_localization` itself.

**Non-Goals:**
- Automatic/machine translation.
- A remote i18n backend or over-the-air string updates.
- A runtime, untyped string-map merge mechanism.
- Any cross-module localization convention (own ARB + `gen-l10n` for other modules'
  demo screens) — out of scope; `vm_storage`, `vm_network`, and `vm_navigation` keep
  their existing hard-coded demo strings and are not touched by this change.
- Retrofitting `vm_storyboard` (no user-facing text of its own today) or any app under
  `apps/` (none exist yet).

## Decisions

### 1. `LocaleRepository` domain interface, in-memory default, `vm_storage`-backed opt-in

`vm_localization`'s domain layer defines `abstract class LocaleRepository` with
`Future<Result<Locale?, LocalizationFailure>> getSaved()` and
`Future<Result<void, LocalizationFailure>> save(Locale locale)`. Two implementations
ship in `data/`:
- `InMemoryLocaleRepository` — default, registered when `VmLocalizationConfig` doesn't
  opt into persistence. Locale resets to config's default on every app restart.
- `VmStorageLocaleRepository` — wraps `KeyValueStore` (from `vm_storage`), registered
  when the app opts in via config (mirrors `VmStorageConfig`'s `enableSecureStore`
  opt-in pattern already established).

`vm_localization`'s `pubspec.yaml` depends on `vm_storage` unconditionally (Dart/pub
has no notion of an optional package dependency within one pubspec); "optional" is
enforced at the config/DI level, exactly like `vm_storage` itself does for its own
secure/document stores.

**Alternative considered**: make `vm_storage` a true optional pub dependency via two
separate packages (`vm_localization` + `vm_localization_storage_bridge`). Rejected as
overengineering for one optional adapter — no other module in this repo splits a
bridge package for a single optional integration.

### 2. Locale-switching Cubit

`VmLocaleCubit extends Cubit<VmLocaleState>` (Freezed state: `locale`, `supportedLocales`).
On construction it reads `LocaleRepository.getSaved()`, falling back to
`VmLocalizationConfig.defaultLocale` if nothing saved or the saved locale isn't in
`supportedLocales`. `changeLocale(Locale)` validates membership in `supportedLocales`,
persists via the repository, and emits. An app's root `MaterialApp` binds
`locale: state.locale` via `BlocBuilder<VmLocaleCubit, VmLocaleState>` — this is the
entire mechanism by which a locale change is observed; `vm_localization` does not
address any other module directly.

### 3. Locale-aware formatting as thin `intl` wrappers

`VmDateFormatter`, `VmNumberFormatter`, `VmCurrencyFormatter` in `domain/` (interfaces)
and `data/` (thin `intl`-backed implementations: `DateFormat`, `NumberFormat`,
`NumberFormat.simpleCurrency`), taking a `Locale` explicitly rather than reading ambient
state — consistent with "no ambient/global state" convention. Currency is inferred from
the locale via `simpleCurrency`; no per-app currency override is introduced (not asked
for in the brief; can be added later without breaking this API if a real need appears).

### 4. Standalone, self-contained example

`vm_localization`'s demo screen (`VmLocalizationDemoScreen`, in `lib/`, exported by the
barrel) shows a language selector (`VmSegmentedControl<Locale>` from `vm_storyboard`)
bound to `VmLocaleCubit`, plus sample date/number/currency values re-rendered on every
locale change. It does not reference or embed any other module's demo screen. The
standalone `example/` registers only `vm_storyboard`, `vm_storage` (to demonstrate the
persistence opt-in), and `vm_localization` — the same "thin shell + `lib/`-owned demo
screen" shape already established by `vm_storage`, `vm_network`, and `vm_navigation`.

## Risks / Trade-offs

- **Saved locale becomes unsupported** (app changes its supported-locales config after
  a user already persisted a locale no longer in that list) → `VmLocaleCubit` falls
  back to `defaultLocale` at startup (Decision 2); never crashes on an invalid saved
  value.

## Migration Plan

Purely additive: a new package with no existing consumers. No other module's
`pubspec.yaml`, barrel, or demo screens change. No consuming app exists yet under
`apps/`, so there's nothing to migrate there. No rollback beyond reverting the change;
nothing is deployed/versioned externally.

## Open Questions

None outstanding — resolved during brief clarification: persistence fallback and
default locale pair are settled in `briefs/6-vm-localization.md`.
