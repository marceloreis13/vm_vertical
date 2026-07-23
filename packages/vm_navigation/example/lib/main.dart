import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_navigation/vm_navigation.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

final getIt = GetIt.instance;

/// Thin runnable shell: registers `vm_storyboard` (theme), `vm_navigation`
/// (navigator service + shared root navigator key) and the example's own
/// in-memory session Cubit, then runs `VmNavigationDemoApp`, which lives in
/// `package:vm_navigation` itself so any app can embed it the same way
/// (see `docs/module-scaffold.md`).
void main() {
  registerVmStoryboardModule(
    getIt,
    config: VmThemeConfig(palette: VmColorPalette.mock(), logo: VmLogo.mock()),
  );

  registerVmNavigationModule(getIt);
  getIt.registerSingleton(
    DemoSessionCubit(),
    dispose: (cubit) => cubit.close(),
  );

  runApp(const VmNavigationDemoApp());
}
