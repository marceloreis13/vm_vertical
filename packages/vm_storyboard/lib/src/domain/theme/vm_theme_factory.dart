import 'package:flutter/material.dart';

import '../tokens/vm_theme_tokens.dart';
import 'vm_color_palette.dart';
import 'vm_theme.dart';

const String vmDefaultFontFamily = 'PlusJakartaSans';

/// Derives the light and dark `ThemeData` from the fixed [tokens] and a
/// validated [palette]/[fontFamily]. Spacing, radius, elevation and motion
/// come from [tokens] and are identical for every app; color and font
/// family come from the app's config.
///
/// Expects [palette] already validated as non-null (see
/// `registerVmStoryboardModule`); this function does not itself validate
/// `VmThemeConfig`.
VmTheme buildVmTheme({
  required VmThemeTokens tokens,
  required VmColorPalette palette,
  String? fontFamily,
  List<ThemeExtension<dynamic>> additionalExtensions = const [],
}) {
  final resolvedFontFamily = fontFamily ?? vmDefaultFontFamily;

  ThemeData themeFor(Brightness brightness) {
    final colorScheme = vmColorSchemeFrom(palette, brightness);
    final textTheme = _textThemeFrom(
      tokens,
      colorScheme,
    ).apply(fontFamily: resolvedFontFamily);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: resolvedFontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      splashFactory: InkSparkle.splashFactory,
      extensions: [tokens, ...additionalExtensions],
    );
  }

  return VmTheme(
    light: themeFor(Brightness.light),
    dark: themeFor(Brightness.dark),
  );
}

TextTheme _textThemeFrom(VmThemeTokens tokens, ColorScheme colorScheme) {
  final typography = tokens.typography;
  TextStyle onSurface(TextStyle style) =>
      style.copyWith(color: colorScheme.onSurface);
  return TextTheme(
    displayLarge: onSurface(typography.displayLarge),
    headlineLarge: onSurface(typography.headlineLarge),
    headlineMedium: onSurface(typography.headlineMedium),
    titleLarge: onSurface(typography.titleLarge),
    titleMedium: onSurface(typography.titleMedium),
    bodyLarge: onSurface(typography.bodyLarge),
    bodyMedium: onSurface(typography.bodyMedium),
    bodySmall: onSurface(typography.bodySmall),
    labelLarge: onSurface(typography.labelLarge),
  );
}
