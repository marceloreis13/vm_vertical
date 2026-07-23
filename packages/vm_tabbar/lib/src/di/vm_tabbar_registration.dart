import 'package:get_it/get_it.dart';

import '../domain/vm_tabbar_config.dart';

/// Single registration entry point for `vm_tabbar`. Registers the
/// app-supplied [config] (tab list + style tokens) in [getIt]; nothing is
/// hard-coded inside the module. `VmTabShellScaffold` resolves
/// `VmTabbarConfig` from [getIt] (or an injected override) when it builds
/// its `VmTabBarCubit`.
void registerVmTabbar(GetIt getIt, VmTabbarConfig config) {
  getIt.registerSingleton<VmTabbarConfig>(config);
}
