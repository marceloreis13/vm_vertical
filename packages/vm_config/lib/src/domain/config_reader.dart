import '../core/config_failure.dart';
import '../core/result.dart';
import '../core/unit.dart';
import 'config_change.dart';
import 'config_map.dart';
import 'vm_environment.dart';

/// The single API consumers depend on to read configuration. No remote
/// source, cache, or vendor SDK type appears in this interface — swapping
/// the remote source never changes a read call site. Resolvable from DI via
/// `registerVmConfigModule`. See `config-reader`.
abstract interface class ConfigReader {
  /// Returns the resolved `bool` for [key] (remote > cache > default), or
  /// [defaultValue] when the key is unresolved or its raw value cannot be
  /// read as a `bool`. Synchronous, non-blocking, never throws.
  bool getBool(String key, bool defaultValue);

  /// Returns the resolved `int` for [key] (remote > cache > default), or
  /// [defaultValue] when the key is unresolved or its raw value cannot be
  /// read as an `int`. Synchronous, non-blocking, never throws.
  int getInt(String key, int defaultValue);

  /// Returns the resolved `double` for [key] (remote > cache > default), or
  /// [defaultValue] when the key is unresolved or its raw value cannot be
  /// read as a `double`. Synchronous, non-blocking, never throws.
  double getDouble(String key, double defaultValue);

  /// Returns the resolved `String` for [key] (remote > cache > default), or
  /// [defaultValue] when the key is unresolved or its raw value cannot be
  /// read as a `String`. Synchronous, non-blocking, never throws.
  String getString(String key, String defaultValue);

  /// Returns the resolved JSON object for [key] (remote > cache > default),
  /// decoded as a `Map<String, dynamic>`, or [defaultValue] when the key is
  /// unresolved or its raw value cannot be read as one. Synchronous,
  /// non-blocking, never throws.
  JsonMap getJson(String key, JsonMap defaultValue);

  /// The active environment, resolved from the injected configuration.
  VmEnvironment get environment;

  /// The app-defined, app-injected typed environment object, held
  /// generically and returned unchanged — `vm_config` declares no
  /// app-specific field. Callers know the concrete type `T` they injected.
  T env<T extends Object>();

  /// A broadcast stream emitting the set of keys whose resolved value
  /// changed, after each successful resolution recompute (e.g. following a
  /// successful [refresh]). Keys whose resolved value did not change are
  /// never included.
  Stream<ConfigChange> get changes;

  /// A stream of the resolved value for [key], emitting the current value
  /// immediately on listen and again every time it changes.
  Stream<T> valueStream<T>(String key, T defaultValue);

  /// Triggers the remote provider's `fetch()`, applies the new snapshot
  /// (emitting [changes] for the keys that changed), and persists it to the
  /// injected cache, if any. Returns `Result<Unit, ConfigFailure>`: success
  /// once the new snapshot is applied, or a [ConfigFailure] when the fetch
  /// fails — in which case reads keep serving the prior snapshot, cache, or
  /// defaults. Never throws.
  Future<Result<Unit, ConfigFailure>> refresh();
}
