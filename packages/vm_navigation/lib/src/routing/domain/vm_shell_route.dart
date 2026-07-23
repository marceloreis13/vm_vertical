import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'vm_branch.dart';

/// A shell-view builder invoked with the live [StatefulNavigationShell] —
/// exposing `currentIndex` and `goBranch` — so it can render the chrome
/// (e.g. a tab bar) around the active branch. `vm_navigation` never renders
/// this chrome itself; it is always supplied by the caller (see
/// `shell-routing`).
typedef VmShellViewBuilder =
    Widget Function(
      BuildContext context,
      GoRouterState state,
      StatefulNavigationShell shell,
    );

/// A typed, module-friendly wrapper over go_router's
/// `StatefulShellRoute.indexedStack`.
///
/// Takes an ordered [branches] list plus a [shellBuilder] and produces a
/// single [RouteBase] via [toRouteBase] — usable directly in
/// `buildVmRouter`'s existing `moduleRouteLists`, alongside any other
/// module's flat `List<RouteBase>`. Every branch keeps its own navigation
/// stack and widget state mounted in an `IndexedStack`, so switching
/// branches never rebuilds an inactive one. Navigating to a location owned
/// by branch *k* makes go_router report `StatefulNavigationShell.currentIndex
/// == k` with no custom URL parsing performed here.
class VmShellRoute {
  const VmShellRoute({required this.branches, required this.shellBuilder});

  /// This shell's branches, in display order. No branch SHALL reference
  /// another branch's or module's routes.
  final List<VmBranch> branches;

  /// Renders the surrounding chrome around the active branch; receives the
  /// live [StatefulNavigationShell].
  final VmShellViewBuilder shellBuilder;

  /// Builds the single [RouteBase] go_router registers for this shell.
  RouteBase toRouteBase() {
    return StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => shellBuilder(context, state, shell),
      branches: [
        for (final branch in branches)
          StatefulShellBranch(routes: branch.routes),
      ],
    );
  }
}
