import '../../core/failure.dart';

/// Lifecycle of one demo scenario in [NetworkDemoScreen]: idle until run,
/// loading while the request is in flight, then success (with a short
/// human-readable summary) or the typed [Failure] it resolved to.
sealed class ScenarioResult {
  const ScenarioResult();
}

final class ScenarioIdle extends ScenarioResult {
  const ScenarioIdle();
}

final class ScenarioLoading extends ScenarioResult {
  const ScenarioLoading({this.note});

  /// Optional progress note, e.g. "retrying (attempt 2)...".
  final String? note;
}

final class ScenarioSuccess extends ScenarioResult {
  const ScenarioSuccess({required this.summary});

  final String summary;
}

final class ScenarioFailure extends ScenarioResult {
  const ScenarioFailure({required this.failure});

  final Failure failure;
}
