import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

void main() {
  group('buildVmTheme', () {
    test('derives both a light and a dark ThemeData', () {
      final tokens = VmThemeTokens.standard();
      final theme = buildVmTheme(
        tokens: tokens,
        palette: VmColorPalette.mock(),
      );

      expect(theme.light.brightness, Brightness.light);
      expect(theme.dark.brightness, Brightness.dark);
      expect(theme.light.extension<VmThemeTokens>(), tokens);
      expect(theme.dark.extension<VmThemeTokens>(), tokens);
    });

    test('falls back to the packaged default font family', () {
      final theme = buildVmTheme(
        tokens: VmThemeTokens.standard(),
        palette: VmColorPalette.mock(),
      );

      expect(theme.light.textTheme.bodyLarge!.fontFamily, vmDefaultFontFamily);
    });

    test('honors an app-provided font family override', () {
      final theme = buildVmTheme(
        tokens: VmThemeTokens.standard(),
        palette: VmColorPalette.mock(),
        fontFamily: 'Roboto',
      );

      expect(theme.light.textTheme.bodyLarge!.fontFamily, 'Roboto');
    });

    test('two apps with different palettes get different colors but identical '
        'spacing/radius/elevation/motion tokens', () {
      final tokens = VmThemeTokens.standard();
      final appA = buildVmTheme(
        tokens: tokens,
        palette: const VmColorPalette(
          primary: Color(0xFF123456),
          secondary: Color(0xFF654321),
          tertiary: Color(0xFF00FF00),
          error: Color(0xFFFF0000),
        ),
      );
      final appB = buildVmTheme(
        tokens: tokens,
        palette: const VmColorPalette(
          primary: Color(0xFFABCDEF),
          secondary: Color(0xFFFEDCBA),
          tertiary: Color(0xFF0000FF),
          error: Color(0xFFFF00FF),
        ),
      );

      expect(
        appA.light.colorScheme.primary,
        isNot(appB.light.colorScheme.primary),
      );
      expect(
        appA.light.extension<VmThemeTokens>(),
        appB.light.extension<VmThemeTokens>(),
      );
    });

    test('attaches app-provided additional ThemeExtensions', () {
      final extension = _FakeExtension();
      final theme = buildVmTheme(
        tokens: VmThemeTokens.standard(),
        palette: VmColorPalette.mock(),
        additionalExtensions: [extension],
      );

      expect(theme.light.extension<_FakeExtension>(), extension);
    });
  });

  group('registerVmStoryboardModule', () {
    late GetIt getIt;

    setUp(() {
      getIt = GetIt.asNewInstance();
    });

    tearDown(() async {
      await getIt.reset();
    });

    test(
      'registers VmThemeConfig, VmThemeTokens and VmTheme as singletons',
      () {
        final config = VmThemeConfig(
          palette: VmColorPalette.mock(),
          logo: VmLogo.mock(),
        );

        registerVmStoryboardModule(getIt, config: config);

        expect(getIt<VmThemeConfig>(), config);
        expect(getIt<VmThemeTokens>(), isA<VmThemeTokens>());
        expect(getIt<VmTheme>(), isA<VmTheme>());
      },
    );

    test('throws VmThemeConfigError when palette is missing', () {
      final config = VmThemeConfig(palette: null, logo: VmLogo.mock());

      expect(
        () => registerVmStoryboardModule(getIt, config: config),
        throwsA(isA<VmThemeConfigError>()),
      );
    });

    test('throws VmThemeConfigError when logo is missing', () {
      final config = VmThemeConfig(palette: VmColorPalette.mock(), logo: null);

      expect(
        () => registerVmStoryboardModule(getIt, config: config),
        throwsA(isA<VmThemeConfigError>()),
      );
    });
  });
}

class _FakeExtension extends ThemeExtension<_FakeExtension> {
  @override
  _FakeExtension copyWith() => _FakeExtension();

  @override
  _FakeExtension lerp(covariant _FakeExtension? other, double t) => this;
}
