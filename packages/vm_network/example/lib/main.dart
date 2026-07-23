import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_network/vm_network.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

final getIt = GetIt.instance;

/// Thin runnable shell: registers `vm_storyboard` (theme) and `vm_network`
/// (with mock, easy-to-tweak config) then runs `NetworkDemoScreen`, which
/// lives in `package:vm_network` itself so any app can embed it the same
/// way (see `docs/module-scaffold.md`).
void main() {
  registerVmStoryboardModule(
    getIt,
    config: VmThemeConfig(palette: VmColorPalette.mock(), logo: VmLogo.mock()),
  );

  registerVmNetworkModule(
    getIt,
    config: VmNetworkConfig(
      baseUrl: 'https://httpbin.org',
      // Easy to tweak: swap for a real token source, disable logging, etc.
      tokenProvider: () async => 'demo-token-123',
      retryPolicy: const RetryPolicy.none(),
      enableLogging: true,
      customInterceptors: const [DemoHeaderInterceptor()],
    ),
  );

  runApp(const VmNetworkExampleApp());
}

class VmNetworkExampleApp extends StatelessWidget {
  const VmNetworkExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = getIt<VmTheme>();
    return MaterialApp(
      title: 'vm_network example',
      theme: theme.light,
      darkTheme: theme.dark,
      home: const NetworkDemoScreen(),
    );
  }
}
