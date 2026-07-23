/// vm_tabbar: a declarative, app-configured bottom tab-bar shell for the
/// vm_core platform. Renders `VmTabBar` and owns tab-selection/badge state
/// via `VmTabBarCubit`, built on `vm_navigation`'s state-preserving
/// `VmShellRoute`/`VmBranch`. The app supplies the tab list (icon, label,
/// branch, optional reactive badge) and style tokens (or accepts the
/// `ThemeData`-derived default); `vm_tabbar` knows no concrete screens and
/// has no dependency on `vm_storyboard`.
library;

export 'src/di/vm_tabbar_registration.dart';
export 'src/domain/vm_badge.dart';
export 'src/domain/vm_tab.dart';
export 'src/domain/vm_tab_bar_state.dart';
export 'src/domain/vm_tab_bar_style.dart';
export 'src/domain/vm_tabbar_config.dart';
export 'src/presentation/demo/demo_badge_source.dart';
export 'src/presentation/demo/vm_tabbar_demo_app.dart';
export 'src/presentation/demo/vm_tabbar_demo_registration.dart';
export 'src/presentation/tabbar/screen/vm_tab_shell_scaffold.dart';
export 'src/presentation/tabbar/views/vm_tab_bar.dart';
export 'src/presentation/tabbar/vm_tab_bar_cubit.dart';
