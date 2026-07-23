import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vm_theme.freezed.dart';

/// Wraps the light and dark `ThemeData` derived from `VmThemeTokens` and a
/// `VmThemeConfig`. Avoids registering `ThemeData` twice in GetIt under the
/// same type.
@freezed
class VmTheme with _$VmTheme {
  const factory VmTheme({required ThemeData light, required ThemeData dark}) =
      _VmTheme;
}
