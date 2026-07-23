// ignore_for_file: prefer_initializing_formals
// (the field is private for encapsulation; the constructor's named
// parameter must stay public, so a plain initializing formal isn't
// available here.)

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/vm_badge.dart';
import '../../domain/vm_tab.dart';
import '../../domain/vm_tab_bar_state.dart';

/// Owns the selected-tab index and per-tab badge state; delegates the
/// actual navigation to the injected `StatefulNavigationShell`. Does not
/// re-implement branch state preservation — that already lives in the
/// shell's `IndexedStack` (see `vm_navigation`'s `VmShellRoute`).
class VmTabBarCubit extends Cubit<VmTabBarState> {
  VmTabBarCubit({
    required StatefulNavigationShell shell,
    required List<VmTab> tabs,
  }) : _shell = shell,
       _tabs = tabs,
       super(VmTabBarState.initial(index: shell.currentIndex)) {
    _subscribeBadges();
  }

  StatefulNavigationShell _shell;
  final List<VmTab> _tabs;
  final Map<int, VoidCallback> _badgeListeners = {};

  /// Requests tab [index] become active. Re-tapping the already-active tab
  /// returns that branch to its root location (via go_router's
  /// `initialLocation: true`) while the Cubit's index stays the same.
  void select(int index) {
    _shell.goBranch(index, initialLocation: index == _shell.currentIndex);
    _sync(index);
  }

  /// Reconciles the Cubit's index (and, if the shell instance changed
  /// across a rebuild, the shell reference used by [select]) with
  /// navigation that originated outside the bar — a deep link or an
  /// external `goBranch` call. The shell is authoritative.
  void syncWithShell(StatefulNavigationShell shell) {
    _shell = shell;
    _sync(shell.currentIndex);
  }

  void _sync(int index) {
    if (state.index != index) {
      emit(state.copyWith(index: index));
    }
  }

  void _subscribeBadges() {
    for (var i = 0; i < _tabs.length; i++) {
      final badge = _tabs[i].badge;
      if (badge == null) continue;

      void listener() => _updateBadge(i, badge.value);
      badge.addListener(listener);
      _badgeListeners[i] = listener;
      _updateBadge(i, badge.value);
    }
  }

  void _updateBadge(int index, VmBadge? value) {
    final badges = Map<int, VmBadge?>.from(state.badges)..[index] = value;
    emit(state.copyWith(badges: badges));
  }

  @override
  Future<void> close() {
    for (var i = 0; i < _tabs.length; i++) {
      final badge = _tabs[i].badge;
      final listener = _badgeListeners[i];
      if (badge != null && listener != null) {
        badge.removeListener(listener);
      }
    }
    _badgeListeners.clear();
    return super.close();
  }
}
