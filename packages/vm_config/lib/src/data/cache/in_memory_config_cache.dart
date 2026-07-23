import '../../domain/config_cache.dart';
import '../../domain/config_map.dart';

/// In-memory [ConfigCache], for tests and the standalone `example/`. Not
/// durable across process restarts. An app that wants durability implements
/// [ConfigCache] itself, typically backed by `vm_storage`'s `DocumentStore`
/// or `KeyValueStore`: load the last persisted snapshot into memory before
/// registering `vm_config`, and persist on [write].
class InMemoryConfigCache implements ConfigCache {
  InMemoryConfigCache([ConfigMap? initial]) : _snapshot = initial;

  ConfigMap? _snapshot;

  @override
  ConfigMap? read() => _snapshot;

  @override
  Future<void> write(ConfigMap snapshot) async {
    _snapshot = snapshot;
  }
}
