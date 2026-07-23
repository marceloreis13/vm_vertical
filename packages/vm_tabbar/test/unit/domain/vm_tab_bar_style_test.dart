import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_tabbar/vm_tabbar.dart';

void main() {
  group('VmTabBarStyle.fromTheme', () {
    test('derives colors from the ambient ColorScheme', () {
      final theme = ThemeData(colorScheme: const ColorScheme.light());

      final style = VmTabBarStyle.fromTheme(theme);

      expect(style.activeColor, theme.colorScheme.primary);
      expect(style.backgroundColor, theme.colorScheme.surface);
      expect(style.badgeColor, theme.colorScheme.error);
    });

    test('copyWith overrides only the given fields', () {
      final base = VmTabBarStyle.fromTheme(ThemeData.light());

      final updated = base.copyWith(height: 72);

      expect(updated.height, 72);
      expect(updated.backgroundColor, base.backgroundColor);
    });
  });

  group('VmBadge', () {
    test('count and dot are distinct, value-equal variants', () {
      expect(const VmBadge.count(3), const VmBadge.count(3));
      expect(const VmBadge.count(3), isNot(const VmBadge.count(4)));
      expect(const VmBadge.dot(), const VmBadge.dot());
      expect(const VmBadge.count(3), isNot(const VmBadge.dot()));
    });
  });
}
