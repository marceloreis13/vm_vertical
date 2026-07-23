import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../domain/theme/vm_theme.dart';
import '../domain/theme/vm_theme_config.dart';
import '../domain/theme/vm_theme_factory.dart';
import '../domain/tokens/vm_theme_tokens.dart';

/// Raised by [registerVmStoryboardModule] when a required part of
/// [VmThemeConfig] is missing.
class VmThemeConfigError extends Error {
  VmThemeConfigError(this.message);

  final String message;

  @override
  String toString() => 'VmThemeConfigError: $message';
}

/// Registers `vm_storyboard` in [getIt]: the injected [config], the fixed
/// `VmThemeTokens`, and the derived `VmTheme` (light/dark `ThemeData`), all
/// as singletons.
///
/// Fails explicitly with a [VmThemeConfigError] when `config.palette` or
/// `config.logo` is missing, instead of silently falling back to a
/// placeholder.
void registerVmStoryboardModule(
  GetIt getIt, {
  required VmThemeConfig config,
  List<ThemeExtension<dynamic>> additionalExtensions = const [],
}) {
  final palette = config.palette;
  if (palette == null) {
    throw VmThemeConfigError(
      'VmThemeConfig.palette is required to register vm_storyboard.',
    );
  }
  if (config.logo == null) {
    throw VmThemeConfigError(
      'VmThemeConfig.logo is required to register vm_storyboard.',
    );
  }

  final tokens = VmThemeTokens.standard();
  final theme = buildVmTheme(
    tokens: tokens,
    palette: palette,
    fontFamily: config.fontFamily,
    additionalExtensions: additionalExtensions,
  );

  getIt.registerSingleton<VmThemeConfig>(config);
  getIt.registerSingleton<VmThemeTokens>(tokens);
  getIt.registerSingleton<VmTheme>(theme);
}
