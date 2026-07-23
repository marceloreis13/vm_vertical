import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_navigation/vm_navigation.dart';
import 'package:vm_tabbar/vm_tabbar.dart';

final getIt = GetIt.instance;

/// Thin runnable shell: registers `vm_navigation` and the `vm_tabbar`
/// example's mock config/badge source, then runs `VmTabbarDemoApp`, which
/// lives in `package:vm_tabbar` itself so any app can embed it the same way
/// (see `docs/module-scaffold.md`).
void main() {
  registerVmNavigationModule(getIt);
  registerVmTabbarDemo(getIt);

  runApp(const VmTabbarDemoApp());
}
