## Why

Apps and modules currently have no consistent way to switch the active locale at
runtime or format dates/numbers/currency per locale. As more modules ship user-facing
screens (and later, `app_weather` / `app_news`), each would otherwise invent its own ad
hoc i18n approach. `vm_localization` establishes this as a standalone module: it owns
which locale is active and how values are formatted, independent of any other module.

## What Changes

- New `vm_localization` module: injected `VmLocalizationConfig` (supported locales,
  default locale, optional persistence), a locale-switching Cubit the app's
  `MaterialApp` observes, a `LocaleRepository` domain interface with an in-memory
  default implementation and an optional `vm_storage`-backed implementation, and
  locale-aware date/number/currency formatting via `intl`.
- New standalone `vm_localization` `example/`: a single self-contained demo screen
  (following the same pattern as `vm_storage`/`vm_network`/`vm_navigation`'s own
  examples — the screen lives in `lib/`, exported by the barrel, `example/` is a thin
  shell) showing a language selector (`pt_BR` default, `en`) and sample date/number/
  currency displays that update at runtime as the locale changes.

`vm_storage`, `vm_network`, and `vm_navigation` are untouched by this change — none of
them depend on `vm_localization`, and `vm_localization` does not embed or reference
their demo screens.

## Capabilities

### New Capabilities
- `vm-localization-configuration`: injected `VmLocalizationConfig`, single DI
  registration entry point, `LocaleRepository` domain interface with in-memory default
  and optional `vm_storage`-backed implementation.
- `locale-switching`: Cubit/service holding the active locale; `MaterialApp` observes it
  and rebuilds on change.
- `locale-aware-formatting`: date, number, and currency formatting per locale via
  `intl`.
- `vm-localization-example`: standalone, self-contained example app with a language
  selector and sample formatted output, demonstrating runtime switching across
  `pt_BR`/`en`.

## Impact

- New package `packages/vm_localization` (barrel, DI registration, domain/data/presentation
  layers, `example/`, tests).
- `pubspec.yaml` workspace: `vm_localization` added to `workspace:`.
- `docs/`: new `docs/vm_localization.md`; `docs/index.md` updated.
- No changes to `vm_storyboard`, `vm_storage`, `vm_network`, `vm_navigation`, or to any
  app under `apps/` (none exist yet).
