// ignore_for_file: prefer_initializing_formals
// (fields are private for encapsulation; the constructor's named parameters
// must stay public, so a plain initializing formal isn't available here.)

import 'dart:async';

import 'package:collection/collection.dart';

import '../../domain/config_cache.dart';
import '../../domain/config_change.dart';
import '../../domain/config_map.dart';
import '../debug/config_debug_log.dart';

const _deepEquality = DeepCollectionEquality();

/// Holds the resolved configuration snapshot and enforces precedence
/// **remote > cache > default**. Resolves defaults (and cache, if wired)
/// synchronously at construction so `ConfigReader` getters are valid before
/// any remote fetch completes. On every recompute (i.e. after a successful
/// remote fetch is applied) it diffs the new resolved snapshot against the
/// previous one and emits `ConfigChange` only for the keys that actually
/// changed. See `config-resolution`.
class ConfigResolutionEngine {
  ConfigResolutionEngine({
    required ConfigMap defaults,
    required ConfigDebugLog debugLog,
    ConfigCache? cache,
  }) : _defaults = defaults,
       _debugLog = debugLog,
       _cache = cache {
    _lastCacheSnapshot = _readCacheSafely() ?? const {};
    _resolved = _merge(
      remote: const {},
      cache: _lastCacheSnapshot,
      defaults: _defaults,
    );
  }

  final ConfigMap _defaults;
  final ConfigDebugLog _debugLog;
  final ConfigCache? _cache;

  late ConfigMap _resolved;
  late ConfigMap _lastCacheSnapshot;

  final StreamController<ConfigChange> _changesController =
      StreamController<ConfigChange>.broadcast();

  /// The currently resolved snapshot (remote > cache > default).
  ConfigMap get resolved => _resolved;

  /// Emits the set of keys whose resolved value changed, after each
  /// recompute. A cache-access or remote-fetch failure never emits.
  Stream<ConfigChange> get changes => _changesController.stream;

  ConfigMap? _readCacheSafely() {
    final cache = _cache;
    if (cache == null) return null;
    try {
      return cache.read();
    } catch (error, stackTrace) {
      _debugLog.reportCacheFailure(error, stackTrace, operation: 'read');
      return null;
    }
  }

  static ConfigMap _merge({
    required ConfigMap remote,
    required ConfigMap cache,
    required ConfigMap defaults,
  }) => <String, Object?>{...defaults, ...cache, ...remote};

  static Set<String> _diff(ConfigMap previous, ConfigMap next) {
    final keys = {...previous.keys, ...next.keys};
    return {
      for (final key in keys)
        if (!_deepEquality.equals(previous[key], next[key])) key,
    };
  }

  /// Applies a new [remote] snapshot from a successful fetch: recomputes the
  /// resolved snapshot, persists [remote] to the cache (if wired, isolating
  /// any write failure), and emits a [ConfigChange] for the keys whose
  /// resolved value changed. Emits nothing when nothing changed.
  Future<void> applyRemoteSnapshot(ConfigMap remote) async {
    final previous = _resolved;
    final next = _merge(
      remote: remote,
      cache: _lastCacheSnapshot,
      defaults: _defaults,
    );
    _resolved = next;

    final cache = _cache;
    if (cache != null) {
      try {
        await cache.write(remote);
        _lastCacheSnapshot = remote;
      } catch (error, stackTrace) {
        _debugLog.reportCacheFailure(error, stackTrace, operation: 'write');
      }
    }

    final changedKeys = _diff(previous, _resolved);
    if (changedKeys.isNotEmpty) {
      _changesController.add(ConfigChange(keys: changedKeys));
    }
  }

  /// Closes the underlying change stream. Only relevant for tests/scoped
  /// containers; the app-wide singleton typically lives for the app's
  /// lifetime and is never disposed.
  Future<void> dispose() => _changesController.close();
}
