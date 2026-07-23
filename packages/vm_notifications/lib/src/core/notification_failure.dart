/// Sealed taxonomy of `vm_notifications` failures. Every failure path of a
/// provider operation (scheduling, cancelling) resolves to one of these
/// variants — never a raw exception.
///
/// Defined locally in `vm_notifications` (`lib/src/core/`) and isolated so it
/// can later migrate to `vm_foundation` without changing consumers' call
/// sites.
sealed class NotificationFailure {
  const NotificationFailure({required this.message, this.cause});

  /// Human/log-friendly description of what went wrong.
  final String message;

  /// The underlying error that produced this failure, if any (kept for
  /// logging/debugging; never rethrown).
  final Object? cause;

  @override
  String toString() => '$runtimeType($message)';
}

/// The injected [LocalScheduler] threw while scheduling a local
/// notification.
final class ScheduleFailure extends NotificationFailure {
  const ScheduleFailure({required super.message, super.cause});
}

/// The injected [LocalScheduler] threw while cancelling a scheduled
/// notification (single or all).
final class CancelFailure extends NotificationFailure {
  const CancelFailure({required super.message, super.cause});
}
