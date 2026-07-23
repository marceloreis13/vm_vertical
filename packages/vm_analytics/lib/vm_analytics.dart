/// vm_analytics: provider-agnostic product analytics for the vm_core
/// platform. Consumers depend on the `AnalyticsTracker` interface only — the
/// consuming app decides providers and configuration via
/// `registerVmAnalyticsModule`. No vendor SDK type appears in the public
/// API. Automatic screen tracking integrates with `vm_navigation` through
/// `AnalyticsRouteObserver`.
library;

export 'src/data/di/vm_analytics_registration.dart';
export 'src/data/providers/debug_analytics_provider.dart';
export 'src/data/providers/noop_analytics_provider.dart';
export 'src/domain/analytics_call.dart';
export 'src/domain/analytics_event.dart';
export 'src/domain/analytics_provider.dart';
export 'src/domain/analytics_tracker.dart';
export 'src/domain/event_name_validator.dart';
export 'src/domain/vm_analytics_config.dart';
export 'src/presentation/demo/analytics_demo_app.dart';
export 'src/presentation/screen_tracking/analytics_route_observer.dart';
