import 'package:freezed_annotation/freezed_annotation.dart';

import 'vm_color_palette.dart';
import 'vm_logo.dart';

part 'vm_theme_config.freezed.dart';

/// What an app injects when registering `vm_storyboard`. `palette` and
/// `logo` are required; `fontFamily` falls back to the module's packaged
/// default font when omitted. Everything else (spacing, radius, elevation,
/// motion) is fixed and not part of this config.
///
/// `palette`/`logo` are typed nullable so that a caller building config
/// dynamically (e.g. from optional app wiring) can still be validated at
/// registration time with an explicit error instead of a compile-time-only
/// guarantee — see `registerVmStoryboardModule`.
@freezed
class VmThemeConfig with _$VmThemeConfig {
  const factory VmThemeConfig({
    required VmColorPalette? palette,
    required VmLogo? logo,
    String? fontFamily,
  }) = _VmThemeConfig;
}
