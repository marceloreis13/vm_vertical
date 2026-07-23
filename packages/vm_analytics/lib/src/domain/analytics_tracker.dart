import 'analytics_event.dart';

/// The single tracking API consumers depend on. No method signature,
/// parameter, or return type references a vendor SDK type — swapping or
/// adding a provider behind [logEvent] and friends never changes a call
/// site. See `analytics-tracker`.
abstract interface class AnalyticsTracker {
  /// Multiplexes [event] to every registered provider. Fire-and-forget: the
  /// returned future always completes without error, even if a provider
  /// throws internally (isolated and reported via the debug seam).
  Future<void> logEvent(AnalyticsEvent event);

  /// Sets a named user property, multiplexed to every registered provider.
  Future<void> setUserProperty(String name, Object? value);

  /// Records a screen view named [name]. [name] follows the same
  /// provider-agnostic naming convention as [AnalyticsEvent.name] and is
  /// validated before reaching any provider — an invalid name throws
  /// [ArgumentError] synchronously rather than being silently forwarded.
  Future<void> screenView(String name);

  /// Associates the current user with [id] across every registered
  /// provider; a `null` id clears it.
  Future<void> setUserId(String? id);

  /// Clears identity/session state across every registered provider, e.g.
  /// on logout.
  Future<void> reset();
}
