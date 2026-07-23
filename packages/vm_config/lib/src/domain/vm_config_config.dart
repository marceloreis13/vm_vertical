import 'config_cache.dart';
import 'config_map.dart';
import 'remote_config_provider.dart';
import 'vm_environment.dart';

/// Configuration for the `vm_config` module, always supplied by the
/// consuming app via `registerVmConfigModule`. No source, key or
/// app-specific value is ever hard-coded inside the module — everything it
/// needs arrives through this value.
class VmConfigConfig {
  const VmConfigConfig({
    required this.provider,
    this.defaults = const {},
    this.environment = VmEnvironment.dev,
    this.env,
    this.cache,
  });

  /// The remote source, translated to the module's port. Consuming apps
  /// implement [RemoteConfigProvider] over a concrete vendor SDK, or use one
  /// of the built-in `local`/`static-map` providers.
  final RemoteConfigProvider provider;

  /// Local defaults, used when neither the remote snapshot nor the cache
  /// resolves a key. A getter's own inline default is used below this.
  final ConfigMap defaults;

  /// The active environment.
  final VmEnvironment environment;

  /// The app-defined, app-owned typed environment object, held generically
  /// by the module and returned unchanged via `ConfigReader.env<T>()`. `null`
  /// when the app has no such object to inject.
  final Object? env;

  /// Optional seam for persisting the last remote snapshot across restarts.
  /// With no cache, precedence collapses to remote > default.
  final ConfigCache? cache;
}
