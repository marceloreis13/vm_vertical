import 'package:freezed_annotation/freezed_annotation.dart';

import 'event_name_validator.dart';

part 'analytics_event.freezed.dart';

/// An immutable, value-equal analytics event: a validated [name] (see
/// `validateAnalyticsName`) and a typed [parameters] map. This is the home
/// of the provider-agnostic event-naming convention — modules add their own
/// typed factory constructors over it (e.g.
/// `AnalyticsEvent.checkoutStarted(...)` as an extension or a static helper
/// in the consuming module), without `vm_analytics` knowing about any
/// specific app event. Providers translate an [AnalyticsEvent] to their own
/// SDK representation.
@freezed
class AnalyticsEvent with _$AnalyticsEvent {
  const AnalyticsEvent._();

  /// Validates [name] against the naming convention at construction time —
  /// an invalid name throws [ArgumentError] and the event is never built,
  /// so it can never reach a provider.
  factory AnalyticsEvent({
    required String name,
    Map<String, Object?> parameters = const {},
  }) {
    return AnalyticsEvent._validated(
      name: validateAnalyticsName(name, label: 'AnalyticsEvent.name'),
      parameters: Map.unmodifiable(parameters),
    );
  }

  const factory AnalyticsEvent._validated({
    required String name,
    required Map<String, Object?> parameters,
  }) = _AnalyticsEvent;
}
