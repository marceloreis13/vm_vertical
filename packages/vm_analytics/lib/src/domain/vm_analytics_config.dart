import 'analytics_provider.dart';

/// Configuration for the `vm_analytics` module, always supplied by the
/// consuming app via `registerVmAnalyticsModule`. Each entry in [providers]
/// is a fully-constructed [AnalyticsProvider] — any vendor key or endpoint a
/// concrete provider needs is embedded in it by the app when it builds the
/// list, so no vendor key or app-specific value is ever hard-coded inside
/// this module.
class VmAnalyticsConfig {
  const VmAnalyticsConfig({
    this.providers = const [],
    this.automaticScreenTracking = true,
  });

  /// The concrete providers every tracking call is multiplexed to. Empty is
  /// a safe no-op.
  final List<AnalyticsProvider> providers;

  /// Whether `AnalyticsRouteObserver` emits a `screenView` automatically on
  /// every route change. When `false`, only manual `screenView(name)` calls
  /// are recorded.
  final bool automaticScreenTracking;
}
