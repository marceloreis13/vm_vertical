import 'package:flutter/material.dart';

import '../../../domain/vm_badge.dart';
import '../../../domain/vm_tab.dart';
import '../../../domain/vm_tab_bar_state.dart';
import '../../../domain/vm_tab_bar_style.dart';

/// The bottom tab bar itself: one item per [tabs] entry (icon + label),
/// active-tab styling driven by [state], and badges rendered from
/// [state.badges]. Purely a View — plain constructor parameters and a
/// callback only, no `Cubit`/`BuildContext` lookups, no IO — so it is
/// pumped standalone in widget/golden tests.
class VmTabBar extends StatelessWidget {
  const VmTabBar({
    required this.tabs,
    required this.state,
    required this.style,
    required this.onTap,
    super.key,
  });

  final List<VmTab> tabs;
  final VmTabBarState state;
  final VmTabBarStyle style;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: style.backgroundColor,
      elevation: style.elevation,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: style.height,
          child: Row(
            children: [
              for (var i = 0; i < tabs.length; i++)
                Expanded(
                  child: _VmTabBarItem(
                    tab: tabs[i],
                    badge: state.badges[i],
                    active: state.index == i,
                    style: style,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VmTabBarItem extends StatelessWidget {
  const _VmTabBarItem({
    required this.tab,
    required this.badge,
    required this.active,
    required this.style,
    required this.onTap,
  });

  final VmTab tab;
  final VmBadge? badge;
  final bool active;
  final VmTabBarStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? style.activeColor : style.inactiveColor;
    final labelStyle = active
        ? style.activeLabelStyle
        : style.inactiveLabelStyle;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(tab.icon, color: color),
              if (badge != null)
                Positioned(
                  right: -8,
                  top: -4,
                  child: _VmBadgeView(badge: badge!, style: style),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(tab.label, style: labelStyle),
        ],
      ),
    );
  }
}

class _VmBadgeView extends StatelessWidget {
  const _VmBadgeView({required this.badge, required this.style});

  final VmBadge badge;
  final VmTabBarStyle style;

  @override
  Widget build(BuildContext context) {
    return switch (badge) {
      VmBadgeDot() => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: style.badgeColor,
          shape: BoxShape.circle,
        ),
      ),
      VmBadgeCount(:final value) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
        decoration: BoxDecoration(
          color: style.badgeColor,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          value > 99 ? '99+' : '$value',
          style: style.badgeTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    };
  }
}
