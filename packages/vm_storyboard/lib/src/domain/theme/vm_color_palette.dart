import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vm_color_palette.freezed.dart';

/// The colors an app MUST supply to register `vm_storyboard`. Used to derive
/// a full light/dark `ColorScheme`; every other token stays fixed.
@freezed
class VmColorPalette with _$VmColorPalette {
  const factory VmColorPalette({
    required Color primary,
    required Color secondary,
    required Color tertiary,
    required Color error,
  }) = _VmColorPalette;

  /// A mock palette for the `example/` gallery and golden tests.
  factory VmColorPalette.mock() => const VmColorPalette(
    primary: Color(0xFF1976D2),
    secondary: Color(0xFF00BCD4),
    tertiary: Color(0xFF3F51B5),
    error: Color(0xFFB3261E),
  );
}

/// Derives a Material 3 `ColorScheme` for the given [brightness] from a
/// [VmColorPalette].
ColorScheme vmColorSchemeFrom(VmColorPalette palette, Brightness brightness) {
  return ColorScheme.fromSeed(
    seedColor: palette.primary,
    secondary: palette.secondary,
    tertiary: palette.tertiary,
    error: palette.error,
    brightness: brightness,
  );
}
