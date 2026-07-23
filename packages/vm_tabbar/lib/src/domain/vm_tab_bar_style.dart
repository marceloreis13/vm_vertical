import 'package:flutter/material.dart';

/// Style tokens `VmTabBar` renders from — colors, icon/label typography,
/// badge appearance, elevation and height. `vm_tabbar` has no dependency on
/// `vm_storyboard`; the app maps its own theme (storyboard or otherwise)
/// into a `VmTabBarStyle`, or omits it entirely and gets [VmTabBarStyle.fromTheme].
@immutable
class VmTabBarStyle {
  const VmTabBarStyle({
    required this.backgroundColor,
    required this.activeColor,
    required this.inactiveColor,
    required this.activeLabelStyle,
    required this.inactiveLabelStyle,
    required this.badgeColor,
    required this.badgeTextStyle,
    this.elevation = 8,
    this.height = 64,
  });

  /// A sensible default derived from the ambient [ThemeData], used when the
  /// app does not inject a [VmTabBarStyle] — keeps `vm_tabbar` runnable
  /// standalone with no storyboard wiring.
  factory VmTabBarStyle.fromTheme(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return VmTabBarStyle(
      backgroundColor: colorScheme.surface,
      activeColor: colorScheme.primary,
      inactiveColor: colorScheme.onSurfaceVariant,
      activeLabelStyle: (theme.textTheme.labelSmall ?? const TextStyle())
          .copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600),
      inactiveLabelStyle: (theme.textTheme.labelSmall ?? const TextStyle())
          .copyWith(color: colorScheme.onSurfaceVariant),
      badgeColor: colorScheme.error,
      badgeTextStyle: TextStyle(
        color: colorScheme.onError,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final TextStyle activeLabelStyle;
  final TextStyle inactiveLabelStyle;
  final Color badgeColor;
  final TextStyle badgeTextStyle;
  final double elevation;
  final double height;

  VmTabBarStyle copyWith({
    Color? backgroundColor,
    Color? activeColor,
    Color? inactiveColor,
    TextStyle? activeLabelStyle,
    TextStyle? inactiveLabelStyle,
    Color? badgeColor,
    TextStyle? badgeTextStyle,
    double? elevation,
    double? height,
  }) {
    return VmTabBarStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      activeLabelStyle: activeLabelStyle ?? this.activeLabelStyle,
      inactiveLabelStyle: inactiveLabelStyle ?? this.inactiveLabelStyle,
      badgeColor: badgeColor ?? this.badgeColor,
      badgeTextStyle: badgeTextStyle ?? this.badgeTextStyle,
      elevation: elevation ?? this.elevation,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VmTabBarStyle &&
        other.backgroundColor == backgroundColor &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor &&
        other.activeLabelStyle == activeLabelStyle &&
        other.inactiveLabelStyle == inactiveLabelStyle &&
        other.badgeColor == badgeColor &&
        other.badgeTextStyle == badgeTextStyle &&
        other.elevation == elevation &&
        other.height == height;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    activeColor,
    inactiveColor,
    activeLabelStyle,
    inactiveLabelStyle,
    badgeColor,
    badgeTextStyle,
    elevation,
    height,
  );
}
