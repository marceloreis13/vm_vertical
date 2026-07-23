import 'dart:async';

import 'package:vm_network/vm_network.dart';

/// In-memory [VmConnectivityGate] with a manual toggle, for
/// `OfflineGateInterceptor`/`VmDioHttpClient` tests.
class FakeConnectivityGate implements VmConnectivityGate {
  FakeConnectivityGate({bool initiallyOnline = true})
    : _isOnline = initiallyOnline;

  bool _isOnline;
  final _controller = StreamController<bool>.broadcast();

  @override
  bool get isOnline => _isOnline;

  @override
  Stream<bool> get onlineChanges => _controller.stream;

  void setOnline(bool online) {
    _isOnline = online;
    _controller.add(online);
  }

  Future<void> dispose() => _controller.close();
}
