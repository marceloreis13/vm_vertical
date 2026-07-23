import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_analytics/vm_analytics.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

final getIt = GetIt.instance;

/// Thin runnable shell: registers `vm_storyboard` (theme) and `vm_analytics`
/// (with only the built-in `debug`/`noop` providers — no real vendor SDK or
/// key, no `apps/` dependency) then runs `AnalyticsDemoApp`, which lives in
/// `package:vm_analytics` itself so any app can embed it the same way (see
/// `docs/module-scaffold.md`).
void main() {
  registerVmStoryboardModule(
    getIt,
    config: VmThemeConfig(palette: VmColorPalette.mock(), logo: VmLogo.mock()),
  );

  // Easy to tweak: swap/add providers or flip automaticScreenTracking below.
  final debugProvider = DebugAnalyticsProvider();
  registerVmAnalyticsModule(
    getIt,
    config: VmAnalyticsConfig(
      providers: [debugProvider, const NoopAnalyticsProvider()],
      automaticScreenTracking: true,
    ),
  );

  runApp(AnalyticsDemoApp(debugProvider: debugProvider));
}
