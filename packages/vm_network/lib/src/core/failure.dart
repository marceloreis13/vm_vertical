import 'json_map.dart';

/// Sealed taxonomy of network-level failures. Every failure path of the HTTP
/// client resolves to one of these variants — never a raw exception.
sealed class Failure {
  const Failure({required this.message, this.cause});

  /// Human/log-friendly description of what went wrong.
  final String message;

  /// The underlying error that produced this failure, if any (kept for
  /// logging/debugging; never rethrown).
  final Object? cause;
}

/// No connectivity: DNS failure, socket/connection error.
final class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.cause});
}

/// A connect, send, or receive timeout was exceeded.
final class TimeoutFailure extends Failure {
  const TimeoutFailure({required super.message, super.cause});
}

/// A non-2xx server response (excluding 401/403, see [UnauthorizedFailure]).
final class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    required this.statusCode,
    this.payload,
    super.cause,
  });

  final int statusCode;

  /// The decoded response body, if any, for caller-side inspection.
  final JsonMap? payload;
}

/// The response body could not be decoded by the caller-supplied decoder.
final class ParsingFailure extends Failure {
  const ParsingFailure({required super.message, super.cause});
}

/// HTTP 401 or 403 — distinct from [ServerFailure] so callers can special-case
/// re-authentication without inspecting a status code.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    required super.message,
    required this.statusCode,
    super.cause,
  });

  final int statusCode;
}

/// Fallback for any error that does not match a specific taxonomy case.
final class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.cause});
}

/// A request was held offline by the connectivity gate longer than the
/// configured `OfflineRequestPolicy.maxWait`.
final class OfflineFailure extends Failure {
  const OfflineFailure({required super.message, super.cause});
}
