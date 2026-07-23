import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../domain/connection_type.dart';
import '../domain/connectivity_source.dart';

/// `connectivity_plus`-backed [ConnectivitySource]. Internal: this class
/// itself is never exported from the barrel (see `live_connectivity_source
/// .dart`'s `createLiveConnectivitySource`, the module's only place that
/// constructs it). Reports only the OS-provided connection type — active
/// internet-reachability probing is a documented future seam.
class ConnectivityPlusSource implements ConnectivitySource {
  ConnectivityPlusSource({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity() {
    unawaited(
      _connectivity.checkConnectivity().then((results) {
        _current = _mapResults(results);
        _controller.add(_current);
      }),
    );
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _current = _mapResults(results);
      _controller.add(_current);
    });
  }

  final Connectivity _connectivity;
  final _controller = StreamController<ConnectionType>.broadcast();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  /// Safe default until the first `checkConnectivity()` resolves.
  ConnectionType _current = ConnectionType.none;

  @override
  ConnectionType get current => _current;

  @override
  Stream<ConnectionType> get onChange => _controller.stream;

  static ConnectionType _mapResults(List<ConnectivityResult> results) {
    for (final result in results) {
      final type = _mapSingle(result);
      if (type != ConnectionType.none) return type;
    }
    return ConnectionType.none;
  }

  static ConnectionType _mapSingle(ConnectivityResult result) =>
      switch (result) {
        ConnectivityResult.wifi => ConnectionType.wifi,
        ConnectivityResult.mobile => ConnectionType.cellular,
        ConnectivityResult.ethernet => ConnectionType.ethernet,
        ConnectivityResult.bluetooth => ConnectionType.bluetooth,
        ConnectivityResult.vpn => ConnectionType.vpn,
        ConnectivityResult.none => ConnectionType.none,
        // `other` and any future OS-reported kind (e.g. `satellite`) map to
        // the catch-all `ConnectionType.other`.
        _ => ConnectionType.other,
      };

  Future<void> dispose() async {
    await _subscription.cancel();
    await _controller.close();
  }
}
