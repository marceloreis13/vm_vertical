# vm_core — project context index

vm_core is a Flutter monorepo (Pub Workspace) assembling apps under `apps/`
from reusable `vm_*` modules under `packages/`.

## Conventions

- [conventions.md](conventions.md) — Clean Architecture + Feature-First, DI
  (GetIt + Injectable), Barrel pattern, code generation.
- [module-scaffold.md](module-scaffold.md) — standard package layout,
  `example/`, `test/`.

## Modules (`packages/`)

| Module | Purpose | Config injected | Docs |
|---|---|---|---|
| `vm_storyboard` | Fixed design tokens (spacing, radius, elevation, motion, typography), light/dark theming and a reusable component library (button, inputs, card, list item, avatar, app bar, chip, badge, snackbar, banner, segmented control, loading/empty/error states, dialog). | `VmThemeConfig` (`palette`, `logo` required; `fontFamily` optional) via `registerVmStoryboardModule(getIt, config: ...)` | See below |
| `vm_network` | Generic, injectable HTTP client with typed `Result`/`Failure` and a standardized failure taxonomy; interceptors for auth, default headers, retry/backoff, flag-controlled logging and an optional offline request policy driven by its own connectivity gate seam (**no `vm_connectivity` dependency**); hides Dio entirely. | `VmNetworkConfig` (`baseUrl` required; headers, token provider, timeouts, retry policy, logging flag, custom interceptors, connectivity gate, offline policy optional) via `registerVmNetworkModule(getIt, config: ...)` | [vm_network.md](vm_network.md) |
| `vm_storage` | Local persistence: `KeyValueStore` (shared_preferences), `SecureStore` (flutter_secure_storage) and `DocumentStore<T>` (Hive CE, TTL + soft-delete) with typed `Result`/`StorageFailure`; hides all three backends entirely. | `VmStorageConfig` (`namespace` required; backend opt-ins, per-collection TTL/soft-delete optional) via `registerVmStorageModule(getIt, config: ...)` | [vm_storage.md](vm_storage.md) |
| `vm_navigation` | Typed, injectable wrapper over `go_router`: per-module `List<RouteBase>` registration with zero coupling between modules, a generic `RouteGuard` contract (no `vm_auth`/`vm_config` dependency) resolved through conditional redirect, and a `BuildContext`-free `VmNavigatorService` for Cubits. | None required; `registerVmNavigationModule(getIt)` returns the shared `GlobalKey<NavigatorState>` to pass to `buildVmRouter(...)` | [vm_navigation.md](vm_navigation.md) |
| `vm_localization` | Runtime locale switching (`VmLocaleCubit` the app's `MaterialApp` observes) and locale-aware date/number/currency formatting via `intl`; `LocaleRepository` with an in-memory default and an optional `vm_storage`-backed implementation. | `VmLocalizationConfig` (`supportedLocales`, `defaultLocale` required; `enablePersistence` optional) via `registerVmLocalizationModule(getIt, config: ...)` | [vm_localization.md](vm_localization.md) |
| `vm_logging` | Injectable, level-based structured logging: a synchronous, non-throwing `Logger` interface (`trace/debug/info/warn/error`, scoped/child loggers), pluggable `LogSink`s with per-sink `minLevel` and error isolation, built-in `noop`/observable `console` sinks, a redaction pipeline (sensitive keys + pluggable redactors), and an optional network-logging adapter with no `vm_network` dependency. | `VmLoggingConfig` (`sinks`, `sensitiveKeys`, `redactors`, all optional — empty is a safe no-op) via `registerVmLogging(getIt, config: ...)` | [vm_logging.md](vm_logging.md) |
| `vm_analytics` | Provider-agnostic product analytics: a single `AnalyticsTracker` interface (`logEvent`, `setUserProperty`, `screenView`, `setUserId`, `reset`) multiplexed to N pluggable `AnalyticsProvider`s with fire-and-forget per-provider error isolation, a validating `AnalyticsEvent` value object (snake_case naming convention), built-in `noop`/observable `debug` providers, and automatic screen tracking via a `vm_navigation` `NavigatorObserver`. Hard dependency on `vm_navigation`. | `VmAnalyticsConfig` (`providers`, `automaticScreenTracking`, both optional — empty providers is a safe no-op) via `registerVmAnalyticsModule(getIt, config: ...)` | [vm_analytics.md](vm_analytics.md) |
| `vm_config` | Injectable, source-agnostic configuration: a single `ConfigReader` interface with synchronous, never-failing typed getters (`getBool/getInt/getDouble/getString/getJson`), precedence **remote > cache > default**, an observable `changes` stream/`valueStream`, a pull-based `RemoteConfigProvider` port (`refresh()` returns `Result<Unit, ConfigFailure>`, isolated on failure) with built-in `local`/observable `static-map` providers, a `VmEnvironment` enum plus a generic app-injected env object, and an optional `ConfigCache` seam with **no `vm_storage` dependency**. | `VmConfigConfig` (`provider` required; `defaults`, `environment`, `env`, `cache` optional) via `registerVmConfigModule(getIt, config: ...)` | [vm_config.md](vm_config.md) |
| `vm_tabbar` | Declarative, app-configured bottom tab-bar shell: `VmTabBar` view + `VmTabBarCubit` (selection, badge state) built on `vm_navigation`'s state-preserving `VmShellRoute`/`VmBranch`; app-injected `VmTab` list (icon, label, branch, optional reactive `Listenable` badge) and `VmTabBarStyle` tokens, with a `ThemeData`-derived default. **No dependency on `vm_storyboard`.** Hard dependency on `vm_navigation`. | `VmTabbarConfig` (`tabs` required; `style` optional) via `registerVmTabbar(getIt, config)` | [vm_tabbar.md](vm_tabbar.md) |
| `vm_notifications` | Provider-agnostic push and local notifications: a single `NotificationService` facade unifying push (token, `tokenChanges`, foreground/background message stream, taps) and local scheduling (`schedule`/`cancel`/`cancelAll`, channels) over pluggable `PushProvider`/`LocalScheduler` ports (one injected `NotificationProvider` implements both), with a built-in in-memory `FakeNotificationProvider`, typed `Result`/`NotificationFailure` isolation, an injected `NotificationRouter` tap→route seam (**no `vm_navigation` dependency**) and an optional `enabled` gate (**no `vm_config` dependency**). | `VmNotificationsConfig` (`provider`, `router` required; `enabled`, `defaultChannels` optional) via `registerVmNotificationsModule(getIt, config: ...)` | [vm_notifications.md](vm_notifications.md) |
| `vm_connectivity` | Injectable, observable online/offline: a sealed `ConnectivityState` (`Online(ConnectionType)` \| `Offline`, derived `isOnline`) driven by an injectable `ConnectivitySource` that hides `connectivity_plus` entirely, exposed via a `ConnectivityCubit` any module or the UI can watch, plus an offline banner composed from `vm_storyboard`. Ships a real bridge into `vm_network`'s own connectivity gate with the dependency inverted (**`vm_network` never depends on this module**). | `VmConnectivityConfig` (`source` required — real via `createLiveConnectivitySource()` or `FakeConnectivitySource`; `debounce` optional) via `registerVmConnectivityModule(getIt, config: ...)` | [vm_connectivity.md](vm_connectivity.md) |

### `vm_storyboard`

Visual design system shared by every app. Spacing, radius, elevation and
motion are **fixed** across all apps (spacious, rounded, softly-elevated,
fluid — Airbnb-inspired); only color palette, logo and (optionally) font
family vary per app.

**Register at app startup:**

```dart
registerVmStoryboardModule(
  getIt,
  config: VmThemeConfig(
    palette: VmColorPalette(
      primary: myPrimaryColor,
      secondary: mySecondaryColor,
      tertiary: myTertiaryColor,
      error: myErrorColor,
    ),
    logo: VmLogo(builder: (context) => const MyAppLogo()),
    // fontFamily: 'MyCustomFont', // optional; defaults to the packaged font
  ),
);
```

`palette` and `logo` are **required** — registration throws
`VmThemeConfigError` if either is missing, instead of silently rendering a
placeholder.

**Use the theme:**

```dart
final theme = getIt<VmTheme>();
MaterialApp(theme: theme.light, darkTheme: theme.dark, ...);
```

Code with no `BuildContext` (Cubits, use cases) can resolve
`getIt<VmThemeConfig>()` / `getIt<VmThemeTokens>()` directly. Widgets read
tokens via `context.vmTokens`.

An app may attach its own `ThemeExtension`s alongside `VmThemeTokens` via
`registerVmStoryboardModule(getIt, config: ..., additionalExtensions: [...])`.

See `packages/vm_storyboard/example/` for a full gallery of every component
in both themes.

## Apps (`apps/`)

_None yet. The current Flutter scaffold lives at the repository root and has
not yet been split into `apps/`._

## Update rule

Whenever a new module is completed, update this index (and add a section to
`conventions.md`/`module-scaffold.md` if the convention itself evolves) before
considering the module done. See `CLAUDE.md` for the pointers kept in sync
with this rule.
