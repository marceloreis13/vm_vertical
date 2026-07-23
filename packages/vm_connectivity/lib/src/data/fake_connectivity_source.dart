import 'dart:async';

import '../domain/connection_type.dart';
import '../domain/connectivity_source.dart';

/// In-memory [ConnectivitySource] with a manual toggle. Backs the standalone
/// `example/` (deterministic online/offline demo, no airplane-mode
/// gymnastics) and the unit tests of state transitions.
class FakeConnectivitySource implements ConnectivitySource {
  FakeConnectivitySource({ConnectionType initial = ConnectionType.wifi})
    : _current = initial;

  ConnectionType _current;
  final _controller = StreamController<ConnectionType>.broadcast();

  @override
  ConnectionType get current => _current;

  @override
  Stream<ConnectionType> get onChange => _controller.stream;

  /// Manually sets the connection type, emitting the change.
  void setType(ConnectionType type) {
    _current = type;
    _controller.add(type);
  }

  /// Convenience: reports [type] (a connected type) — defaults to wifi.
  void goOnline([ConnectionType type = ConnectionType.wifi]) => setType(type);

  /// Convenience: reports `ConnectionType.none`.
  void goOffline() => setType(ConnectionType.none);

  Future<void> dispose() => _controller.close();
}
