## 1. Scaffold

- [x] 1.1 Create `packages/vm_localization` per module-scaffold (barrel `lib/vm_localization.dart`, `lib/src/`, `example/`, `test/`, `resolution: workspace`)
- [x] 1.2 Add package to root `workspace:` list in `pubspec.yaml`
- [x] 1.3 Add deps (`intl`, `flutter_localizations`, `vm_storage`) and dev deps (`build_runner`, `freezed`, `injectable_generator`, `mocktail`); include shared `analysis_options.yaml`

## 2. Core — Result & Failures

- [x] 2.1 Define `Result<S, F>` in `lib/src/core/` (isolated for future `vm_foundation`, matching `vm_storage`'s pattern)
- [x] 2.2 Define sealed `LocalizationFailure` (e.g. persistence-backend, unsupported-locale) with Freezed and exhaustive matching
- [x] 2.3 Unit tests: success/failure carry values; failure variants match expected cases

## 3. Configuration & DI

- [x] 3.1 Define `VmLocalizationConfig` (supported locales, default locale, persistence opt-in flag)
- [x] 3.2 Implement single `registerVmLocalizationModule(GetIt, {required VmLocalizationConfig})` entry point in the barrel (GetIt + Injectable)
- [x] 3.3 Unit tests: config drives registration; no hard-coded locale list/default in module source

## 4. LocaleRepository

- [x] 4.1 Define `LocaleRepository` domain interface (`getSaved`/`save`, typed `Result`)
- [x] 4.2 Implement `InMemoryLocaleRepository` (default)
- [x] 4.3 Implement `VmStorageLocaleRepository` backed by `vm_storage`'s `KeyValueStore`
- [x] 4.4 Wire selective registration: in-memory by default, `vm_storage`-backed when persistence is opted into via config
- [x] 4.5 Unit tests: read with nothing saved, save-then-read roundtrip, selective registration (default vs opted-in)

## 5. Locale-Switching Cubit

- [x] 5.1 Define `VmLocaleState` (Freezed: `locale`, `supportedLocales`)
- [x] 5.2 Implement `VmLocaleCubit`: startup resolution (saved locale if supported, else config default), `changeLocale(Locale)` with supported-locale validation and persistence
- [x] 5.3 Unit tests: startup with valid saved locale, startup with no saved locale, startup with unsupported saved locale falls back to default, changing to supported locale emits+persists, changing to unsupported locale is a no-op

## 6. Locale-Aware Formatting

- [x] 6.1 Define `VmDateFormatter`, `VmNumberFormatter`, `VmCurrencyFormatter` domain interfaces (locale passed explicitly)
- [x] 6.2 Implement `intl`-backed formatters (`DateFormat`, `NumberFormat`, `NumberFormat.simpleCurrency`)
- [x] 6.3 Unit tests: date/number/currency formatting differs correctly between `pt_BR` and `en`

## 7. Example App

- [x] 7.1 Revert `vm_storage`, `vm_network`, `vm_navigation` retrofits back to hard-coded demo strings: remove `l10n.yaml`/`lib/l10n/`/generated localizations, barrel delegate exports, and `example/` `MaterialApp` delegate registration added for this change
- [x] 7.2 Build `vm_localization`'s own demo screen (`VmLocalizationDemoScreen`, in `lib/`, exported by the barrel — same shape as `vm_storage`/`vm_network`/`vm_navigation`'s own screens): a language selector (`pt_BR`/`en`) and sample date/number/currency displays driven by `VmLocaleCubit`
- [x] 7.3 `example/` is a thin shell: registers `vm_storyboard`, `vm_storage` (to exercise the persistence opt-in), and `vm_localization` with a sample `VmLocalizationConfig`, then runs `VmLocalizationDemoScreen` — no dependency on `vm_network`/`vm_navigation`
- [x] 7.4 Confirm the example runs and that one language switch updates the selector's own state and the sample formats (built, launched, and screenshotted on iOS simulator)

## 8. Docs & Verification

- [x] 8.1 Add `docs/vm_localization.md` and update `docs/index.md` per project rule; remove any `vm_storage.md`/`vm_network.md`/`vm_navigation.md`/`conventions.md` edits made for the reverted retrofit
- [x] 8.2 Run `dart analyze` (barrel/implementation-imports clean) and `dart format`
- [x] 8.3 Run `build_runner` for `vm_localization` and the full test suite for all four packages; ensure green
