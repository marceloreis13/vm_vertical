// ignore_for_file: prefer_initializing_formals
// (fields are private for encapsulation; the constructor's named parameters
// must stay public, so a plain initializing formal isn't available here.)

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/providers/static_map_config_provider.dart';
import '../../domain/config_cache.dart';
import '../../domain/config_change.dart';
import '../../domain/config_map.dart';
import '../../domain/config_reader.dart';
import 'config_demo_state.dart';

/// Key/label pairs for the flags the visual example toggles. Kept as a
/// simple, easy-to-tweak list (see `docs/module-scaffold.md`).
const Map<String, String> kConfigDemoFields = {
  'new_checkout': 'New checkout flow',
  'max_items': 'Max items per page',
  'theme': 'Theme',
};

/// Drives the `vm_config` visual example: reads through the app-registered
/// [ConfigReader] and mutates the shared [StaticMapConfigProvider] and
/// [ConfigCache] so the example can demonstrate both the observable change
/// stream (toggle -> refresh -> UI updates) and the remote > cache >
/// default precedence (clearing a remote key falls back live).
class ConfigDemoCubit extends Cubit<ConfigDemoState> {
  ConfigDemoCubit({
    required ConfigReader reader,
    required StaticMapConfigProvider provider,
    required ConfigMap defaultValues,
    ConfigCache? cache,
  }) : _reader = reader,
       _provider = provider,
       _defaultValues = defaultValues,
       _cache = cache,
       super(ConfigDemoState.initial()) {
    _changesSubscription = _reader.changes.listen((_) => _reload());
    _reload();
    unawaited(_reader.refresh());
  }

  final ConfigReader _reader;
  final StaticMapConfigProvider _provider;
  final ConfigMap _defaultValues;
  final ConfigCache? _cache;
  late final StreamSubscription<ConfigChange> _changesSubscription;

  void _reload() {
    final cacheValues = _cache?.read() ?? const {};
    final remoteValues = _provider.currentValues;
    emit(
      ConfigDemoState(
        fields: [
          for (final entry in kConfigDemoFields.entries)
            ConfigDemoField(
              key: entry.key,
              label: entry.value,
              defaultValue: _defaultValues[entry.key],
              cacheValue: cacheValues[entry.key],
              remoteValue: remoteValues[entry.key],
              resolvedValue: _resolvedValue(entry.key),
            ),
        ],
      ),
    );
  }

  Object? _resolvedValue(String key) => switch (key) {
    'new_checkout' => _reader.getBool(
      key,
      _defaultValues['new_checkout'] as bool? ?? false,
    ),
    'max_items' => _reader.getInt(
      key,
      _defaultValues['max_items'] as int? ?? 0,
    ),
    'theme' => _reader.getString(
      key,
      _defaultValues['theme'] as String? ?? 'light',
    ),
    _ => null,
  };

  /// Flips `new_checkout` in the remote provider and refreshes.
  Future<void> toggleNewCheckout() async {
    final current = _provider.currentValues['new_checkout'] as bool? ?? false;
    _provider.set('new_checkout', !current);
    await _reader.refresh();
  }

  /// Cycles `max_items` through a fixed set of demo values and refreshes.
  Future<void> cycleMaxItems() async {
    const cycle = [10, 20, 30];
    final current = _provider.currentValues['max_items'] as int?;
    final nextIndex = (cycle.indexOf(current ?? -1) + 1) % cycle.length;
    _provider.set('max_items', cycle[nextIndex]);
    await _reader.refresh();
  }

  /// Cycles `theme` through a fixed set of demo values and refreshes.
  Future<void> cycleTheme() async {
    const cycle = ['light', 'dark', 'system'];
    final current = _provider.currentValues['theme'] as String?;
    final nextIndex = (cycle.indexOf(current ?? '') + 1) % cycle.length;
    _provider.set('theme', cycle[nextIndex]);
    await _reader.refresh();
  }

  /// Removes [key] from the remote provider and refreshes, demonstrating
  /// fallback to cache, then default.
  Future<void> clearRemote(String key) async {
    _provider.remove(key);
    await _reader.refresh();
  }

  @override
  Future<void> close() {
    unawaited(_changesSubscription.cancel());
    return super.close();
  }
}
