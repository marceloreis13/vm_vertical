import 'package:get_it/get_it.dart';

import '../../domain/analytics_tracker.dart';
import '../../domain/vm_analytics_config.dart';
import '../../presentation/screen_tracking/analytics_route_observer.dart';
import '../debug/analytics_debug_log.dart';
import '../tracker/multiplexing_analytics_tracker.dart';

/// Single registration entry point for `vm_analytics`. Receives its [config]
/// from the consuming app — no provider, key or screen-tracking default is
/// hard-coded inside the module. Registers the fan-out [AnalyticsTracker]
/// (multiplexing to [VmAnalyticsConfig.providers]) and the
/// [AnalyticsRouteObserver] the app wires into its `GoRouter(observers: ...)`
/// for automatic screen tracking.
void registerVmAnalyticsModule(
  GetIt getIt, {
  required VmAnalyticsConfig config,
}) {
  getIt.registerSingleton<VmAnalyticsConfig>(config);

  final tracker = MultiplexingAnalyticsTracker(
    providers: config.providers,
    debugLog: const DeveloperAnalyticsDebugLog(),
  );
  getIt.registerSingleton<AnalyticsTracker>(tracker);

  getIt.registerSingleton<AnalyticsRouteObserver>(
    AnalyticsRouteObserver(tracker: tracker, config: config),
  );
}
