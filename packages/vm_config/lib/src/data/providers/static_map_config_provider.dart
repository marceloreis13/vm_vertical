import '../../core/config_failure.dart';
import '../../core/result.dart';
import '../../domain/config_map.dart';
import '../../domain/remote_config_provider.dart';

/// Built-in observable [RemoteConfigProvider] backed by a mutable in-memory
/// map. Mutating the map via [set]/[remove] has no effect until the next
/// `fetch()` (triggered by `ConfigReader.refresh()`), letting an app or the
/// `example/` toggle flags/values at runtime and watch the resolved values
/// and `changes` stream react, with no real vendor SDK. See
/// `config-providers`.
class StaticMapConfigProvider implements RemoteConfigProvider {
  StaticMapConfigProvider([ConfigMap initial = const {}])
    : _values = Map.of(initial);

  final Map<String, Object?> _values;

  /// The current in-memory map, for inspection (e.g. by a demo UI). Does
  /// not reflect what `ConfigReader` has resolved until a `refresh()` runs.
  ConfigMap get currentValues => Map.unmodifiable(_values);

  /// Sets [key] to [value]. Takes effect on the next `fetch()`.
  void set(String key, Object? value) => _values[key] = value;

  /// Removes [key] so it no longer contributes a remote value. Takes effect
  /// on the next `fetch()`.
  void remove(String key) => _values.remove(key);

  @override
  Future<Result<ConfigMap, ConfigFailure>> fetch() async =>
      Success(Map.unmodifiable(_values));
}
