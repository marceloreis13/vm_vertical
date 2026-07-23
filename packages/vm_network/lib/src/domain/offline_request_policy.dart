/// Drives the offline-gate interceptor: how long a request may be held
/// while the connectivity gate reports offline before failing typed. Only
/// takes effect when `VmNetworkConfig.gate` is configured.
class OfflineRequestPolicy {
  const OfflineRequestPolicy({this.maxWait = const Duration(seconds: 30)});

  /// The bound on how long a request is held offline before the interceptor
  /// completes it with an `OfflineFailure`. Holding-and-resuming is the
  /// point of the policy; pass `Duration.zero` for fail-fast behavior.
  final Duration maxWait;
}
