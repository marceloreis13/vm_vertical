# `vm_connectivity`

Injectable, observable online/offline connectivity module for the vm_core
platform. Connectivity is exposed as a sealed `ConnectivityState`
(`Online(ConnectionType)` | `Offline`, with a derived `isOnline`) driven by an
injectable `ConnectivitySource` — the `connectivity_plus`-backed
implementation lives in `lib/src/` and is never exported from the barrel, the
same pattern as Dio in `vm_network`. Active "real internet reachability"
probing (DNS/HTTP ping) is **out of scope** this iteration; the source
reports only the OS-provided connection type. `ConnectionType.none` always
maps to `Offline`.

## Register at app startup

```dart
registerVmConnectivityModule(
  getIt,
  config: VmConnectivityConfig(
    source: createLiveConnectivitySource(), // or a FakeConnectivitySource
    debounce: const Duration(milliseconds: 300), // optional, default: none
  ),
);
```

`source` is the only required field — nothing here is hard-coded inside the
module. `createLiveConnectivitySource()` is the module's single "injectable
default wiring" entry point: the only place a concrete `connectivity_plus`
source is constructed.

## Observe connectivity

Resolve `ConnectivityCubit` from the container and watch it like any other
Cubit:

```dart
final state = context.watch<ConnectivityCubit>().state;
switch (state) {
  ConnectivityOnline(:final type) => print('online via $type'),
  ConnectivityOffline() => print('offline'),
}
```

Or drop the ready-made banner anywhere in the widget tree — it shows itself
only while `Offline` and hides itself while `Online`:

```dart
Scaffold(
  body: Column(
    children: [
      const OfflineBannerSection(), // consumer-overridable `message`
      Expanded(child: MyScreen()),
    ],
  ),
)
```

`OfflineBannerSection` reads the nearest `BlocProvider<ConnectivityCubit>`
(typically the one `registerVmConnectivityModule` registers) and renders
`OfflineBannerView`, composed from `vm_storyboard`'s `VmBanner` — no new
primitive was needed, so nothing was promoted this change.

## Bridge into `vm_network` (inverted dependency)

`vm_network` owns its **own** abstract connectivity gate (`VmConnectivityGate`)
and an offline request policy interceptor — it never imports
`vm_connectivity` or `connectivity_plus`. `vm_connectivity` ships an adapter
mapping `ConnectivityState.isOnline` onto that gate; the app wires the two
together in its composition root:

```dart
final gateAdapter = VmConnectivityNetworkGateAdapter(getIt<ConnectivityRepository>());

registerVmNetworkModule(
  getIt,
  config: VmNetworkConfig(
    baseUrl: 'https://api.example.com',
    gate: gateAdapter, // optional; absent = no offline gating, prior behavior
    offlinePolicy: const OfflineRequestPolicy(maxWait: Duration(seconds: 30)),
  ),
);
```

While the gate reports offline, `vm_network` holds outbound requests and
resumes them once it reports online again; if the hold exceeds
`offlinePolicy.maxWait`, the request completes with a typed
`OfflineFailure` (never a raw exception). See
[vm_network.md](vm_network.md#offline-gate-bridge) for the interceptor side.

### Future extension: real reachability probing

`ConnectivitySource` only reports the OS connection type today (wifi has a
router, not necessarily internet). The contract is typed so a future
reachability-probing source (DNS/HTTP ping, debounced) can implement the same
`ConnectivitySource` interface and be swapped in via `VmConnectivityConfig`
with no change to consumers, the Cubit, the banner or the `vm_network`
bridge.

## Built-in fake source

`FakeConnectivitySource` is an in-memory `ConnectivitySource` with a manual
toggle (`goOnline([type])` / `goOffline()` / `setType(type)`) — no airplane
mode required. Used by the module's own unit tests and by `example/`.

## Visual example

`packages/vm_connectivity/example/` is a standalone Flutter app (no `apps/`
dependency) that registers the module with `FakeConnectivitySource` and wires
the `vm_network` bridge in its composition root. The demo
(`ConnectivityDemoScreen`) lives in `lib/` and is exported by the barrel, so
any app can embed it directly via
`package:vm_connectivity/vm_connectivity.dart` — `example/` is only a thin
shell that registers the modules and runs it. Buttons toggle the fake source
online/offline (reflecting the banner and status label immediately) and send
a request through the `vm_network` bridge, showing it held while offline and
resumed once back online.
