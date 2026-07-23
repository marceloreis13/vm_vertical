import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_config/vm_config.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

final getIt = GetIt.instance;

/// Easy to tweak: change the initial remote/cache/default values below to
/// see how precedence (remote > cache > default) resolves differently.
const _defaults = <String, Object?>{
  'new_checkout': false,
  'max_items': 5,
  'theme': 'light',
};

/// Thin runnable shell: registers `vm_storyboard` (theme) and `vm_config`
/// (with mock, easy-to-tweak config) then runs `ConfigDemoScreen`, which
/// lives in `package:vm_config` itself so any app can embed it the same way
/// (see `docs/module-scaffold.md`).
void main() {
  registerVmStoryboardModule(
    getIt,
    config: VmThemeConfig(palette: VmColorPalette.mock(), logo: VmLogo.mock()),
  );

  final provider = StaticMapConfigProvider(const {
    'new_checkout': true,
    'max_items': 10,
  });
  final cache = InMemoryConfigCache(const {'max_items': 25, 'theme': 'dark'});

  registerVmConfigModule(
    getIt,
    config: VmConfigConfig(
      provider: provider,
      defaults: _defaults,
      environment: VmEnvironment.dev,
      cache: cache,
    ),
  );

  runApp(VmConfigExampleApp(provider: provider, cache: cache));
}

class VmConfigExampleApp extends StatelessWidget {
  const VmConfigExampleApp({
    required this.provider,
    required this.cache,
    super.key,
  });

  final StaticMapConfigProvider provider;
  final ConfigCache cache;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<VmTheme>();
    return MaterialApp(
      title: 'vm_config example',
      theme: theme.light,
      darkTheme: theme.dark,
      home: ConfigDemoScreen(
        provider: provider,
        cache: cache,
        defaultValues: _defaults,
      ),
    );
  }
}
