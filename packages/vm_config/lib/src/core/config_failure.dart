/// Sealed taxonomy of `vm_config` failures. Every failure path of a remote
/// fetch or cache access resolves to one of these variants — never a raw
/// exception. `ConfigFailure` only ever surfaces from `refresh()`/fetch
/// paths; reads through `ConfigReader` never produce one.
///
/// Defined locally in `vm_config` (`lib/src/core/`) and isolated so it can
/// later migrate to `vm_foundation` without changing consumers' call sites.
sealed class ConfigFailure {
  const ConfigFailure({required this.message, this.cause});

  /// Human/log-friendly description of what went wrong.
  final String message;

  /// The underlying error that produced this failure, if any (kept for
  /// logging/debugging; never rethrown).
  final Object? cause;

  @override
  String toString() => '$runtimeType($message)';
}

/// The remote provider's `fetch()` failed or threw.
final class RemoteFetchFailure extends ConfigFailure {
  const RemoteFetchFailure({required super.message, super.cause});
}

/// A read from or write to the injected [ConfigCache] failed or threw.
final class CacheAccessFailure extends ConfigFailure {
  const CacheAccessFailure({required super.message, super.cause});
}
