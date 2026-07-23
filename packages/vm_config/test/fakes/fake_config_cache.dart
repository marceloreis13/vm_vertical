import 'package:vm_config/vm_config.dart';

/// A hand-written fake [ConfigCache] that can be made to throw on [read] or
/// [write] to exercise cache-access failure isolation.
class FakeConfigCache implements ConfigCache {
  FakeConfigCache([ConfigMap? initial]) : _snapshot = initial;

  ConfigMap? _snapshot;
  bool throwOnRead = false;
  bool throwOnWrite = false;
  final List<ConfigMap> writes = [];

  @override
  ConfigMap? read() {
    if (throwOnRead) throw StateError('read failed');
    return _snapshot;
  }

  @override
  Future<void> write(ConfigMap snapshot) async {
    if (throwOnWrite) throw StateError('write failed');
    writes.add(snapshot);
    _snapshot = snapshot;
  }
}
