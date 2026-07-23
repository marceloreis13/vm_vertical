/// Drives the retry/backoff interceptor: how many attempts, how long to wait
/// between them, and which failures are worth retrying at all.
class RetryPolicy {
  const RetryPolicy({
    this.maxAttempts = 3,
    this.backoff = _defaultBackoff,
    this.retriableStatusCodes = const {502, 503, 504},
  });

  /// No retries: every request is attempted exactly once.
  const RetryPolicy.none()
    : maxAttempts = 1,
      backoff = _defaultBackoff,
      retriableStatusCodes = const {};

  /// Total attempts including the first (non-retry) one. Must be >= 1.
  final int maxAttempts;

  /// Delay before the [attempt]-th retry (1-based: 1 is the first retry).
  final Duration Function(int attempt) backoff;

  /// Server status codes considered transient/idempotent-safe to retry.
  /// 401/403 and other 4xx are never retried regardless of this set.
  final Set<int> retriableStatusCodes;

  static Duration _defaultBackoff(int attempt) =>
      Duration(milliseconds: 200 * attempt);
}
