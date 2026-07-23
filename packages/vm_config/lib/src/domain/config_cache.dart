import 'config_map.dart';

/// Injectable seam for persisting and reading back the last successfully
/// resolved remote snapshot. `vm_config` never depends on `vm_storage` in
/// its pubspec; an app that wants persistence across restarts implements
/// this port itself (e.g. backed by `vm_storage`'s `DocumentStore` or
/// `KeyValueStore`) and injects it via `VmConfigConfig.cache`.
///
/// When no [ConfigCache] is injected, precedence collapses to
/// remote > default and no persistence occurs — see `config-resolution`.
abstract interface class ConfigCache {
  /// Synchronously returns the last persisted snapshot, if any. Called once
  /// at registration so `ConfigReader` getters resolve to a cached value
  /// before any remote fetch completes. An app that persists asynchronously
  /// (e.g. via `vm_storage`) is expected to have loaded this value into
  /// memory before constructing its [ConfigCache] implementation and
  /// registering the module.
  ConfigMap? read();

  /// Persists [snapshot] as the last known good remote snapshot, called
  /// after every successful `refresh()`. A failing write is isolated by the
  /// caller and reported via the module's logging seam; it never fails a
  /// refresh.
  Future<void> write(ConfigMap snapshot);
}
