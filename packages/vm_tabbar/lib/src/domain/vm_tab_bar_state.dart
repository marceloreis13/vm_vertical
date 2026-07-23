import 'package:freezed_annotation/freezed_annotation.dart';

import 'vm_badge.dart';

part 'vm_tab_bar_state.freezed.dart';

/// `VmTabBarCubit`'s state: the selected tab index and each tab's current
/// badge value (keyed by the tab's position in the configured `List<VmTab>`;
/// absent from the map or `null` means "no badge").
@freezed
class VmTabBarState with _$VmTabBarState {
  const factory VmTabBarState({
    required int index,
    required Map<int, VmBadge?> badges,
  }) = _VmTabBarState;

  factory VmTabBarState.initial({int index = 0}) =>
      VmTabBarState(index: index, badges: const {});
}
