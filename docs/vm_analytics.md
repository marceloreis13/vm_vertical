# `vm_analytics`

Provider-agnostic product analytics for the vm_core platform. Consumers depend
on a single `AnalyticsTracker` interface — the consuming app decides which
concrete providers (Firebase, Amplitude, …) receive calls and how they're
configured. No vendor SDK type crosses the barrel, and automatic screen
tracking integrates with `vm_navigation` (a **hard dependency**) via a
`NavigatorObserver`.

## Register at app startup

```dart
final debugProvider = DebugAnalyticsProvider();

registerVmAnalyticsModule(
  getIt,
  config: VmAnalyticsConfig(
    providers: [
      debugProvider,
      MyFirebaseAnalyticsProvider(apiKey: myFirebaseKey), // app-owned, not vm_analytics
    ],
    automaticScreenTracking: true,
  ),
);
```

Nothing is hard-coded inside the module — providers, their vendor keys (each
provider embeds its own when the app constructs it) and the screen-tracking
toggle always come from the consuming app. An empty `VmAnalyticsConfig()` (no
providers) makes tracking a safe no-op.

## Use the tracker

```dart
final tracker = getIt<AnalyticsTracker>();

await tracker.logEvent(AnalyticsEvent(
  name: 'checkout_started',
  parameters: {'item_count': 3},
));
await tracker.setUserProperty('plan', 'pro');
await tracker.setUserId(user.id);
await tracker.reset(); // e.g. on logout
```

Every call is **fire-and-forget** (`Future<void>`): it fans out to every
registered provider, each isolated in its own `try`/`catch`, so one throwing
provider never blocks the others or reaches the call site. Zero providers is
a safe no-op.

## `AnalyticsEvent` naming convention

`AnalyticsEvent.name` (and manual `screenView(name)`) is validated at
construction: snake_case, starting with a lowercase letter, only lowercase
letters/digits/underscores, at most `kAnalyticsNameMaxLength` (40) characters.
An invalid name throws `ArgumentError` immediately rather than being silently
forwarded to a provider. Add typed factory constructors/static helpers over
`AnalyticsEvent` in your own module for its events (e.g.
`AnalyticsEvent.checkoutStarted(itemCount: 3)`) — `vm_analytics` stays
ignorant of any specific app event.

## Providers

`AnalyticsProvider` is the pluggable port — implement `logEvent`,
`setUserProperty`, `screenView`, `setUserId` and `reset` to add a new vendor;
no change to `AnalyticsTracker` or its call sites is needed.

Built in:

- **`NoopAnalyticsProvider`** — discards everything; for standalone runs and
  tests.
- **`DebugAnalyticsProvider`** — logs via `dart:developer` and exposes an
  **observable** record of received calls (`buffer`, `calls` stream) so a UI
  can render them live — see the visual example below.

## Automatic screen tracking

`AnalyticsRouteObserver` is a `NavigatorObserver` — wire it into your
`GoRouter(observers: [routeObserver])` (resolve it from `getIt` after
registration) and every route change emits a `screenView` automatically,
sanitized to the naming convention from the route's `Page.name`/
`RouteSettings.name`. Gated by `VmAnalyticsConfig.automaticScreenTracking`; a
manual `tracker.screenView('checkout')` remains available for flows the
observer can't name.

## Visual example

`packages/vm_analytics/example/` is a standalone Flutter app dispatching
sample events, user properties, and identity calls, and navigating between
two screens to demonstrate automatic screen tracking — rendering each call
live via `DebugAnalyticsProvider`'s observable stream. The demo app
(`AnalyticsDemoApp`) lives in `lib/` and is exported by the barrel, so any app
can embed it directly via `package:vm_analytics/vm_analytics.dart` — the
`example/` app is only a thin shell that registers the module and runs it.

## Out of scope

Concrete vendor providers (Firebase, Amplitude, …) — apps implement
`AnalyticsProvider` themselves. Dashboards, querying, data analysis, consent/
GDPR gating and offline event queuing/batching are not part of this module.
