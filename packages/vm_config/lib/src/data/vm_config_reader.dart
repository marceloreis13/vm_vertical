// ignore_for_file: prefer_initializing_formals
// (fields are private for encapsulation; the constructor's named parameters
// must stay public, so a plain initializing formal isn't available here.)

import 'dart:async';

import '../core/config_failure.dart';
import '../core/result.dart';
import '../core/unit.dart';
import '../domain/config_change.dart';
import '../domain/config_map.dart';
import '../domain/config_reader.dart';
import '../domain/remote_config_provider.dart';
import '../domain/vm_environment.dart';
import 'debug/config_debug_log.dart';
import 'resolution/config_resolution_engine.dart';

/// The [ConfigReader] implementation: total, synchronous typed reads over
/// the engine's resolved snapshot, and a [refresh] that fetches through the
/// injected [RemoteConfigProvider], isolating any failure so a bad remote
/// never breaks a read. See `config-reader` and `config-providers`.
class VmConfigReaderImpl implements ConfigReader {
  VmConfigReaderImpl({
    required RemoteConfigProvider provider,
    required ConfigResolutionEngine engine,
    required VmEnvironment environment,
    required ConfigDebugLog debugLog,
    Object? envObject,
  }) : _provider = provider,
       _engine = engine,
       _environment = environment,
       _debugLog = debugLog,
       _envObject = envObject;

  final RemoteConfigProvider _provider;
  final ConfigResolutionEngine _engine;
  final VmEnvironment _environment;
  final ConfigDebugLog _debugLog;
  final Object? _envObject;

  @override
  VmEnvironment get environment => _environment;

  @override
  T env<T extends Object>() => _envObject as T;

  @override
  bool getBool(String key, bool defaultValue) => _read(key, defaultValue);

  @override
  int getInt(String key, int defaultValue) => _read(key, defaultValue);

  @override
  double getDouble(String key, double defaultValue) => _read(key, defaultValue);

  @override
  String getString(String key, String defaultValue) => _read(key, defaultValue);

  @override
  JsonMap getJson(String key, JsonMap defaultValue) => _read(key, defaultValue);

  T _read<T>(String key, T defaultValue) {
    final raw = _engine.resolved[key];
    if (raw == null) return defaultValue;
    if (raw is T) return raw as T;
    _debugLog.reportTypeMismatch(
      key: key,
      expected: T,
      actual: raw.runtimeType,
    );
    return defaultValue;
  }

  @override
  Stream<ConfigChange> get changes => _engine.changes;

  @override
  Stream<T> valueStream<T>(String key, T defaultValue) {
    late final StreamController<T> controller;
    StreamSubscription<ConfigChange>? subscription;
    controller = StreamController<T>.broadcast(
      onListen: () {
        controller.add(_read(key, defaultValue));
        subscription = _engine.changes
            .where((change) => change.keys.contains(key))
            .listen((_) => controller.add(_read(key, defaultValue)));
      },
      onCancel: () async {
        await subscription?.cancel();
        await controller.close();
      },
    );
    return controller.stream;
  }

  @override
  Future<Result<Unit, ConfigFailure>> refresh() async {
    final Result<ConfigMap, ConfigFailure> fetchResult;
    try {
      fetchResult = await _provider.fetch();
    } catch (error, stackTrace) {
      final failure = RemoteFetchFailure(
        message: 'Unhandled error while fetching remote config',
        cause: error,
      );
      _debugLog.reportFetchFailure(failure, stackTrace: stackTrace);
      return Err(failure);
    }

    return switch (fetchResult) {
      Success<ConfigMap, ConfigFailure>(value: final snapshot) =>
        await _applySnapshot(snapshot),
      Err<ConfigMap, ConfigFailure>(value: final failure) => _reportFailure(
        failure,
      ),
    };
  }

  Future<Result<Unit, ConfigFailure>> _applySnapshot(ConfigMap snapshot) async {
    await _engine.applyRemoteSnapshot(snapshot);
    return const Success(Unit.value);
  }

  Result<Unit, ConfigFailure> _reportFailure(ConfigFailure failure) {
    _debugLog.reportFetchFailure(failure);
    return Err(failure);
  }
}
