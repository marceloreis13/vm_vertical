import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_connectivity/vm_connectivity.dart';
import 'package:vm_network/vm_network.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

final getIt = GetIt.instance;

/// Thin runnable shell: registers `vm_storyboard` (theme), `vm_connectivity`
/// (with a fake source with a manual toggle) and `vm_network` (wired with
/// the `VmConnectivityNetworkGateAdapter`, demonstrating the real bridge)
/// then runs `ConnectivityDemoScreen`, which lives in
/// `package:vm_connectivity` itself so any app can embed it the same way.
/// Easy to tweak (see `docs/module-scaffold.md`): swap the fake source for
/// `createLiveConnectivitySource()` to drive it from the real OS state.
void main() {
  registerVmStoryboardModule(
    getIt,
    config: VmThemeConfig(palette: VmColorPalette.mock(), logo: VmLogo.mock()),
  );

  final fakeSource = FakeConnectivitySource();
  registerVmConnectivityModule(
    getIt,
    config: VmConnectivityConfig(source: fakeSource),
  );

  // Composition root: wires vm_connectivity's adapter into vm_network's own
  // gate seam. vm_network never imports vm_connectivity — only this app
  // does, at the boundary.
  final gateAdapter = VmConnectivityNetworkGateAdapter(
    getIt<ConnectivityRepository>(),
  );
  registerVmNetworkModule(
    getIt,
    config: VmNetworkConfig(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      gate: gateAdapter,
      offlinePolicy: const OfflineRequestPolicy(maxWait: Duration(seconds: 8)),
    ),
  );

  runApp(VmConnectivityExampleApp(fakeSource: fakeSource));
}

class VmConnectivityExampleApp extends StatelessWidget {
  const VmConnectivityExampleApp({required this.fakeSource, super.key});

  final FakeConnectivitySource fakeSource;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<VmTheme>();
    return MaterialApp(
      title: 'vm_connectivity example',
      theme: theme.light,
      darkTheme: theme.dark,
      home: ConnectivityDemoScreen(fakeSource: fakeSource),
    );
  }
}
