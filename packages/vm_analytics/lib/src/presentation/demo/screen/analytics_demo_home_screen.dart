import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../data/providers/debug_analytics_provider.dart';
import '../../../domain/analytics_tracker.dart';
import '../analytics_demo_cubit.dart';
import '../analytics_demo_routes.dart';
import '../sections/analytics_call_list_section.dart';
import '../sections/demo_controls_section.dart';

/// Entry point of the `vm_analytics` visual example. Resolves the
/// app-registered [AnalyticsTracker] and the [DebugAnalyticsProvider]
/// instance the app wired into it (via `registerVmAnalyticsModule`) and
/// drives [AnalyticsDemoCubit] with them. Lives in `lib/`, not `example/`,
/// so any other app (e.g. `app_showcase`) can embed it directly — see
/// `docs/module-scaffold.md`.
class AnalyticsDemoHomeScreen extends StatelessWidget {
  const AnalyticsDemoHomeScreen({
    required this.debugProvider,
    this.getIt,
    super.key,
  });

  /// The [DebugAnalyticsProvider] instance registered into
  /// `VmAnalyticsConfig`, so the demo can subscribe to exactly what was
  /// delivered to it.
  final DebugAnalyticsProvider debugProvider;

  /// Defaults to [GetIt.instance]; overridable for tests/embedding apps
  /// with a scoped container.
  final GetIt? getIt;

  @override
  Widget build(BuildContext context) {
    final container = getIt ?? GetIt.instance;
    final tracker = container<AnalyticsTracker>();
    final tokens = context.vmTokens;

    return BlocProvider(
      create: (_) =>
          AnalyticsDemoCubit(tracker: tracker, debugProvider: debugProvider),
      child: Scaffold(
        appBar: const VmAppBar(title: 'vm_analytics example'),
        body: Column(
          children: [
            const DemoControlsSection(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spacing.md),
              child: Align(
                alignment: Alignment.centerLeft,
                child: VmButton(
                  label: 'Go to details (auto screen tracking)',
                  variant: VmButtonVariant.text,
                  onPressed: () =>
                      context.push(const AnalyticsDemoDetailsRoute().location),
                ),
              ),
            ),
            SizedBox(height: tokens.spacing.sm),
            const Expanded(child: AnalyticsCallListSection()),
          ],
        ),
      ),
    );
  }
}
