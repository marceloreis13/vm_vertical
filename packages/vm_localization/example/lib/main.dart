import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_localization/vm_localization.dart';
import 'package:vm_storage/vm_storage.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

final getIt = GetIt.instance;

const _supportedLocales = [Locale('pt', 'BR'), Locale('en')];

/// Thin runnable shell: registers `vm_storyboard` (theme), `vm_storage`
/// (so the persistence opt-in below has a `KeyValueStore` to use), and
/// `vm_localization`, then runs `VmLocalizationDemoScreen`, which lives in
/// `package:vm_localization` itself so any app can embed it the same way
/// (see `docs/module-scaffold.md`).
void main() {
  registerVmStoryboardModule(
    getIt,
    config: VmThemeConfig(palette: VmColorPalette.mock(), logo: VmLogo.mock()),
  );

  registerVmStorageModule(
    getIt,
    config: const VmStorageConfig(namespace: 'vm_localization_example'),
  );

  registerVmLocalizationModule(
    getIt,
    config: const VmLocalizationConfig(
      supportedLocales: _supportedLocales,
      defaultLocale: Locale('pt', 'BR'),
      enablePersistence: true,
    ),
  );

  runApp(const VmLocalizationExampleApp());
}

class VmLocalizationExampleApp extends StatelessWidget {
  const VmLocalizationExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = getIt<VmTheme>();
    return BlocProvider.value(
      value: getIt<VmLocaleCubit>(),
      child: BlocBuilder<VmLocaleCubit, VmLocaleState>(
        builder: (context, localeState) {
          return MaterialApp(
            title: 'vm_localization example',
            theme: theme.light,
            darkTheme: theme.dark,
            locale: localeState.locale,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: _supportedLocales,
            home: const VmLocalizationDemoScreen(),
          );
        },
      ),
    );
  }
}
