import 'analytics_event.dart';

/// The port every concrete analytics provider implements. Mirrors
/// [AnalyticsTracker]'s operations: the tracker's job is validation and
/// fan-out, a provider's job is translating each call to its own vendor SDK.
/// Any number of providers can be registered without changing
/// `AnalyticsTracker` or any call site — see `analytics-providers`.
abstract interface class AnalyticsProvider {
  /// Translates and forwards [event] to this provider's SDK.
  Future<void> logEvent(AnalyticsEvent event);

  /// Sets a named user property on this provider.
  Future<void> setUserProperty(String name, Object? value);

  /// Records a screen view named [name] (already validated by the tracker).
  Future<void> screenView(String name);

  /// Associates the current user with [id]; a `null` id clears it.
  Future<void> setUserId(String? id);

  /// Clears all identity/session state held by this provider (e.g. logout).
  Future<void> reset();
}
