import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'vm_badge.dart';

/// A single, app-declared tab: an icon, a label, the index of the
/// `VmBranch` (in the shell's branch list) its content lives in, and an
/// optional reactive badge source.
///
/// `vm_tabbar` never references a concrete screen or a design-system
/// package through this value object — the app supplies the icon/label and
/// wires [branchIndex] to its own `VmShellRoute` branches.
@immutable
class VmTab {
  const VmTab({
    required this.icon,
    required this.label,
    required this.branchIndex,
    this.badge,
  });

  /// The icon shown for this tab.
  final IconData icon;

  /// The label shown for this tab.
  final String label;

  /// Index into the shell's `VmBranch` list this tab activates.
  final int branchIndex;

  /// Optional reactive badge source; `null` means this tab never shows a
  /// badge. When non-null, `VmTabBarCubit` subscribes to it and folds its
  /// current value into `VmTabBarState`.
  final ValueListenable<VmBadge?>? badge;
}
