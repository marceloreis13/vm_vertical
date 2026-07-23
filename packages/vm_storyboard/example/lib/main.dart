import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import 'mock_palettes.dart';

final getIt = GetIt.instance;

void main() {
  registerVmStoryboardModule(
    getIt,
    config: VmThemeConfig(palette: VmColorPalette.mock(), logo: VmLogo.mock()),
  );
  runApp(const VmStoryboardGalleryApp());
}

/// The runnable shell: owns the app's `ThemeMode` and, for this demo, which
/// `VmColorPalette` is active — only a widget above `MaterialApp` can
/// rebuild its `theme`/`darkTheme`/`themeMode`. Everything below is
/// `GalleryScreen`, which lives in the package itself so it can also be the
/// golden-test baseline (see `vm_storyboard/test/golden`).
class VmStoryboardGalleryApp extends StatefulWidget {
  const VmStoryboardGalleryApp({super.key});

  @override
  State<VmStoryboardGalleryApp> createState() => _VmStoryboardGalleryAppState();
}

class _VmStoryboardGalleryAppState extends State<VmStoryboardGalleryApp> {
  ThemeMode _themeMode = ThemeMode.light;
  String _paletteName = 'Ocean';

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  void _changePalette(String? name) {
    if (name == null) return;
    setState(() => _paletteName = name);
  }

  @override
  Widget build(BuildContext context) {
    // Spacing/radius/elevation/motion (VmThemeTokens) stay exactly as
    // registered — only the palette changes here, exactly like an app
    // switching its brand colors would. Nothing below GalleryScreen ever
    // needs to know a palette changed.
    final theme = buildVmTheme(
      tokens: getIt<VmThemeTokens>(),
      palette: mockPalettes[_paletteName]!,
      fontFamily: getIt<VmThemeConfig>().fontFamily,
    );
    return MaterialApp(
      title: 'vm_storyboard gallery',
      theme: theme.light,
      darkTheme: theme.dark,
      themeMode: _themeMode,
      home: GalleryScreen(
        onToggleTheme: _toggleTheme,
        themeMode: _themeMode,
        extraActions: [
          DropdownMenu<String>(
            initialSelection: _paletteName,
            onSelected: _changePalette,
            dropdownMenuEntries: [
              for (final name in mockPalettes.keys)
                DropdownMenuEntry(value: name, label: name),
            ],
          ),
        ],
      ),
    );
  }
}
