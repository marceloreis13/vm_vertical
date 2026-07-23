# `vm_localization`

Runtime locale switching and locale-aware formatting for the vm_core
platform. Owns *which* locale is active app-wide and `intl`-based date/
number/currency formatting — it does not own any module's string catalog
(see "Module-owned localization catalogs" in `docs/conventions.md` for that).

## Register at app startup

```dart
registerVmLocalizationModule(
  getIt,
  config: const VmLocalizationConfig(
    supportedLocales: [Locale('pt', 'BR'), Locale('en')],
    defaultLocale: Locale('pt', 'BR'),
    enablePersistence: true, // optional, default false
  ),
);
```

`supportedLocales` and `defaultLocale` are required. `enablePersistence`
opts into a `vm_storage`-backed `LocaleRepository` (requires `vm_storage` to
already be registered in the same `GetIt`); otherwise the locale resets to
`defaultLocale` on every app restart (in-memory repository).

## Locale switching

```dart
final cubit = getIt<VmLocaleCubit>();

BlocBuilder<VmLocaleCubit, VmLocaleState>(
  builder: (context, state) => MaterialApp(
    locale: state.locale,
    supportedLocales: state.supportedLocales,
    // ...
  ),
);

await cubit.changeLocale(const Locale('en')); // no-op if not supported
```

At startup, the Cubit resolves the saved locale (if any and still in
`supportedLocales`), falling back to `defaultLocale` otherwise. Binding the
app's root `MaterialApp.locale` to `state.locale` is the entire mechanism by
which a locale change reflects across every mounted module: Flutter's own
localization resolution re-runs for every `Localizations.of<T>(context)`
call — including each module's own generated delegate — the moment
`MaterialApp.locale` changes. `vm_localization` never addresses another
module directly.

## Locale-aware formatting

```dart
final date = getIt<VmDateFormatter>().format(DateTime.now(), locale);
final number = getIt<VmNumberFormatter>().format(1234.5, locale);
final price = getIt<VmCurrencyFormatter>().format(19.9, locale);
```

Each formatter takes the `Locale` explicitly — no ambient/global locale
state. Currency symbol/format is inferred from the locale via `intl`'s
`NumberFormat.simpleCurrency`.

## Visual example

`packages/vm_localization/example/` is a standalone Flutter app (no `apps/`
dependency): a language selector plus sample date/number/currency displays
(`LocaleSection`, exported by the barrel), embedding `vm_storage`,
`vm_network` and `vm_navigation`'s own retrofitted demo screens in adjacent
tabs — switching the language once updates every one of them simultaneously.
The `example/` app registers all four modules (aggregating each module's
`localizationsDelegates`/`supportedLocales` into its own `MaterialApp`) and
is the copy-pasteable reference for how a real app aggregates delegates.

## Local `Result`/`LocalizationFailure`

`Result<S, F>` and the sealed `LocalizationFailure` taxonomy are defined
locally in `lib/src/core/`, isolated so a future `vm_foundation` migration is
a re-home rather than a rewrite. Consumers should only depend on the
barrel-exported types, not reach into `lib/src/`.
