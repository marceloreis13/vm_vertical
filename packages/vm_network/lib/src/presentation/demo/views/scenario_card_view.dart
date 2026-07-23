import 'package:flutter/material.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../core/failure.dart';
import '../scenario_result.dart';

/// Renders one [ScenarioResult] via the shared `VmAsyncActionCard`,
/// translating the `vm_network` [ScenarioResult]/`Failure` into the plain
/// parameters the generic card expects. Takes no Cubit/State — pure View.
class ScenarioCardView extends StatelessWidget {
  const ScenarioCardView({
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.result,
    required this.onPressed,
    super.key,
  });

  final String title;
  final String description;
  final String buttonLabel;
  final ScenarioResult result;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return switch (result) {
      ScenarioIdle() => VmAsyncActionCard(
        title: title,
        description: description,
        status: VmAsyncStatus.idle,
        buttonLabel: buttonLabel,
        onPressed: onPressed,
      ),
      ScenarioLoading(:final note) => VmAsyncActionCard(
        title: title,
        description: note ?? description,
        status: VmAsyncStatus.loading,
        buttonLabel: buttonLabel,
        onPressed: onPressed,
      ),
      ScenarioSuccess(:final summary) => VmAsyncActionCard(
        title: title,
        description: description,
        status: VmAsyncStatus.success,
        buttonLabel: buttonLabel,
        onPressed: onPressed,
        successContent: Text(summary),
      ),
      ScenarioFailure(:final failure) => VmAsyncActionCard(
        title: title,
        description: description,
        status: VmAsyncStatus.error,
        buttonLabel: buttonLabel,
        onPressed: onPressed,
        errorMessage: _describe(failure),
      ),
    };
  }

  String _describe(Failure failure) => switch (failure) {
    NetworkFailure(:final message) => 'Network failure: $message',
    TimeoutFailure(:final message) => 'Timeout: $message',
    ServerFailure(:final statusCode, :final message) =>
      'Server error $statusCode: $message',
    ParsingFailure(:final message) => 'Parsing failure: $message',
    UnauthorizedFailure(:final statusCode) =>
      'Unauthorized ($statusCode): credentials were rejected',
    UnknownFailure(:final message) => 'Unknown failure: $message',
    OfflineFailure(:final message) => 'Offline: $message',
  };
}
