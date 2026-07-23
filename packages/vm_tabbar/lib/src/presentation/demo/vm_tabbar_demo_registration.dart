import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../di/vm_tabbar_registration.dart';
import '../../domain/vm_tab.dart';
import '../../domain/vm_tabbar_config.dart';
import 'demo_badge_source.dart';

/// Registers everything the `vm_tabbar` visual example needs: a live
/// [DemoBadgeSource] (disposed by [getIt] itself) and the module's own
/// [registerVmTabbar] call, configured with three mock tabs bound to the
/// example's three branches (see `demo_routes.dart`).
void registerVmTabbarDemo(GetIt getIt) {
  final badgeSource = DemoBadgeSource()..start();
  getIt.registerSingleton<DemoBadgeSource>(
    badgeSource,
    dispose: (source) => source.dispose(),
  );

  registerVmTabbar(
    getIt,
    VmTabbarConfig(
      tabs: [
        const VmTab(icon: Icons.home, label: 'Home', branchIndex: 0),
        const VmTab(icon: Icons.search, label: 'Search', branchIndex: 1),
        VmTab(
          icon: Icons.person,
          label: 'Profile',
          branchIndex: 2,
          badge: badgeSource.notifier,
        ),
      ],
    ),
  );
}
