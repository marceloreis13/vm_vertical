import 'analytics_event.dart';

/// A closed set describing one call received by the built-in `debug`
/// provider, in the shape it was received (already validated/multiplexed).
/// Consumed with an exhaustive `switch` — e.g. by the visual example that
/// renders the `debug` provider's observable record on-screen.
sealed class AnalyticsCall {
  const AnalyticsCall();

  const factory AnalyticsCall.logEvent(AnalyticsEvent event) = LogEventCall;

  const factory AnalyticsCall.setUserProperty({
    required String name,
    required Object? value,
  }) = SetUserPropertyCall;

  const factory AnalyticsCall.screenView(String name) = ScreenViewCall;

  const factory AnalyticsCall.setUserId(String? id) = SetUserIdCall;

  const factory AnalyticsCall.reset() = ResetCall;

  /// A one-line, human-readable description used for developer-log output
  /// and as a fallback label in the example UI.
  String describe();
}

class LogEventCall extends AnalyticsCall {
  const LogEventCall(this.event);

  final AnalyticsEvent event;

  @override
  String describe() => 'logEvent(${event.name}, ${event.parameters})';
}

class SetUserPropertyCall extends AnalyticsCall {
  const SetUserPropertyCall({required this.name, required this.value});

  final String name;
  final Object? value;

  @override
  String describe() => 'setUserProperty($name, $value)';
}

class ScreenViewCall extends AnalyticsCall {
  const ScreenViewCall(this.name);

  final String name;

  @override
  String describe() => 'screenView($name)';
}

class SetUserIdCall extends AnalyticsCall {
  const SetUserIdCall(this.id);

  final String? id;

  @override
  String describe() => 'setUserId(${id ?? 'null'})';
}

class ResetCall extends AnalyticsCall {
  const ResetCall();

  @override
  String describe() => 'reset()';
}
