import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vm_theme_tokens.freezed.dart';

/// Spacing scale, in logical pixels. Generous by default (Airbnb-inspired
/// spaciousness), shared by every app that registers `vm_storyboard`.
@freezed
class VmSpacingTokens with _$VmSpacingTokens {
  const factory VmSpacingTokens({
    required double xs,
    required double sm,
    required double md,
    required double lg,
    required double xl,
    required double xxl,
  }) = _VmSpacingTokens;

  factory VmSpacingTokens.standard() =>
      const VmSpacingTokens(xs: 4, sm: 8, md: 16, lg: 24, xl: 32, xxl: 48);
}

/// Corner radius scale, in logical pixels. Large surfaces (cards, dialogs,
/// banners) get the roundest corners; small elements (chips, badges) get the
/// tightest.
@freezed
class VmRadiusTokens with _$VmRadiusTokens {
  const factory VmRadiusTokens({
    required double sm,
    required double md,
    required double lg,
    required double xl,
  }) = _VmRadiusTokens;

  factory VmRadiusTokens.standard() =>
      const VmRadiusTokens(sm: 8, md: 12, lg: 16, xl: 24);
}

/// Soft, diffused elevation levels (no glass/blur effect). Each level is a
/// ready-to-use shadow list for `BoxDecoration.boxShadow`.
@freezed
class VmElevationTokens with _$VmElevationTokens {
  const factory VmElevationTokens({
    required List<BoxShadow> level1,
    required List<BoxShadow> level2,
    required List<BoxShadow> level3,
  }) = _VmElevationTokens;

  factory VmElevationTokens.standard() {
    List<BoxShadow> soft({required double blur, required double dy}) => [
      BoxShadow(
        color: const Color(0x1F000000),
        blurRadius: blur,
        offset: Offset(0, dy),
      ),
    ];
    return VmElevationTokens(
      level1: soft(blur: 8, dy: 2),
      level2: soft(blur: 16, dy: 6),
      level3: soft(blur: 28, dy: 12),
    );
  }
}

/// Motion durations and easing. Fluid over fast: slower durations with
/// smooth, emphasized easing.
@freezed
class VmMotionTokens with _$VmMotionTokens {
  const factory VmMotionTokens({
    required Duration fast,
    required Duration medium,
    required Duration slow,
    required Curve curve,
  }) = _VmMotionTokens;

  factory VmMotionTokens.standard() => const VmMotionTokens(
    fast: Duration(milliseconds: 250),
    medium: Duration(milliseconds: 300),
    slow: Duration(milliseconds: 350),
    curve: Curves.easeInOutCubic,
  );
}

/// Typographic scale: size/weight/height only. Font family is applied by the
/// active `ThemeData`, never hard-coded here (see `theming`).
@freezed
class VmTypographyTokens with _$VmTypographyTokens {
  const factory VmTypographyTokens({
    required TextStyle displayLarge,
    required TextStyle headlineLarge,
    required TextStyle headlineMedium,
    required TextStyle titleLarge,
    required TextStyle titleMedium,
    required TextStyle bodyLarge,
    required TextStyle bodyMedium,
    required TextStyle bodySmall,
    required TextStyle labelLarge,
  }) = _VmTypographyTokens;

  factory VmTypographyTokens.standard() => const VmTypographyTokens(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      height: 1.12,
      letterSpacing: -0.25,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.2,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.22,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.43,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.33,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.43,
      letterSpacing: 0.1,
    ),
  );
}

/// Single entry point for every fixed design token: spacing, radius,
/// elevation, motion and typography. Identical across every app that
/// registers `vm_storyboard` (see the `design-tokens` spec).
///
/// Written as a plain immutable class rather than `@freezed`: Freezed
/// generates `copyWith` as a getter (for its fluent copyWith builder), which
/// clashes with `ThemeExtension.copyWith()` being a method — the analyzer
/// rejects that as `inconsistent_inheritance_getter_and_method`.
@immutable
class VmThemeTokens extends ThemeExtension<VmThemeTokens> {
  const VmThemeTokens({
    required this.spacing,
    required this.radius,
    required this.elevation,
    required this.motion,
    required this.typography,
  });

  /// The platform's single fixed default: spacious, rounded, softly
  /// elevated, fluid and typographically expressive.
  factory VmThemeTokens.standard() => VmThemeTokens(
    spacing: VmSpacingTokens.standard(),
    radius: VmRadiusTokens.standard(),
    elevation: VmElevationTokens.standard(),
    motion: VmMotionTokens.standard(),
    typography: VmTypographyTokens.standard(),
  );

  final VmSpacingTokens spacing;
  final VmRadiusTokens radius;
  final VmElevationTokens elevation;
  final VmMotionTokens motion;
  final VmTypographyTokens typography;

  @override
  VmThemeTokens copyWith({
    VmSpacingTokens? spacing,
    VmRadiusTokens? radius,
    VmElevationTokens? elevation,
    VmMotionTokens? motion,
    VmTypographyTokens? typography,
  }) {
    return VmThemeTokens(
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
      elevation: elevation ?? this.elevation,
      motion: motion ?? this.motion,
      typography: typography ?? this.typography,
    );
  }

  @override
  VmThemeTokens lerp(covariant VmThemeTokens? other, double t) {
    if (other == null) return this;
    return VmThemeTokens(
      spacing: VmSpacingTokens(
        xs: lerpDouble(spacing.xs, other.spacing.xs, t),
        sm: lerpDouble(spacing.sm, other.spacing.sm, t),
        md: lerpDouble(spacing.md, other.spacing.md, t),
        lg: lerpDouble(spacing.lg, other.spacing.lg, t),
        xl: lerpDouble(spacing.xl, other.spacing.xl, t),
        xxl: lerpDouble(spacing.xxl, other.spacing.xxl, t),
      ),
      radius: VmRadiusTokens(
        sm: lerpDouble(radius.sm, other.radius.sm, t),
        md: lerpDouble(radius.md, other.radius.md, t),
        lg: lerpDouble(radius.lg, other.radius.lg, t),
        xl: lerpDouble(radius.xl, other.radius.xl, t),
      ),
      elevation: t < 0.5 ? elevation : other.elevation,
      motion: t < 0.5 ? motion : other.motion,
      typography: VmTypographyTokens(
        displayLarge: TextStyle.lerp(
          typography.displayLarge,
          other.typography.displayLarge,
          t,
        )!,
        headlineLarge: TextStyle.lerp(
          typography.headlineLarge,
          other.typography.headlineLarge,
          t,
        )!,
        headlineMedium: TextStyle.lerp(
          typography.headlineMedium,
          other.typography.headlineMedium,
          t,
        )!,
        titleLarge: TextStyle.lerp(
          typography.titleLarge,
          other.typography.titleLarge,
          t,
        )!,
        titleMedium: TextStyle.lerp(
          typography.titleMedium,
          other.typography.titleMedium,
          t,
        )!,
        bodyLarge: TextStyle.lerp(
          typography.bodyLarge,
          other.typography.bodyLarge,
          t,
        )!,
        bodyMedium: TextStyle.lerp(
          typography.bodyMedium,
          other.typography.bodyMedium,
          t,
        )!,
        bodySmall: TextStyle.lerp(
          typography.bodySmall,
          other.typography.bodySmall,
          t,
        )!,
        labelLarge: TextStyle.lerp(
          typography.labelLarge,
          other.typography.labelLarge,
          t,
        )!,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VmThemeTokens &&
          other.spacing == spacing &&
          other.radius == radius &&
          other.elevation == elevation &&
          other.motion == motion &&
          other.typography == typography);

  @override
  int get hashCode =>
      Object.hash(spacing, radius, elevation, motion, typography);
}

double lerpDouble(double a, double b, double t) => a + (b - a) * t;
