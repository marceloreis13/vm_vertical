import 'package:flutter/foundation.dart';

import 'vm_tab.dart';
import 'vm_tab_bar_style.dart';

/// The app-injected configuration `registerVmTabbar` receives: the ordered
/// tab list and (optionally) style tokens. `null` [style] falls back to
/// `VmTabBarStyle.fromTheme` at render time. Nothing in this module is
/// hard-coded — both fields always come from the consuming app.
@immutable
class VmTabbarConfig {
  const VmTabbarConfig({required this.tabs, this.style});

  /// Ordered tabs; each tab's `branchIndex` must reference a valid branch
  /// in the app's `VmShellRoute`.
  final List<VmTab> tabs;

  /// Style tokens for `VmTabBar`; `null` uses the ambient `ThemeData`.
  final VmTabBarStyle? style;
}
