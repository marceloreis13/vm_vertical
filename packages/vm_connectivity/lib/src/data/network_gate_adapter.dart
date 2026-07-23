import 'package:vm_network/vm_network.dart';

import '../domain/connectivity_repository.dart';

/// Adapts `ConnectivityRepository`'s `ConnectivityState.isOnline` onto
/// `vm_network`'s `VmConnectivityGate` seam, so an app can feed connectivity
/// into the network offline policy without `vm_network` importing
/// `vm_connectivity`. The app wires this adapter into
/// `VmNetworkConfig.gate` in its composition root.
class VmConnectivityNetworkGateAdapter implements VmConnectivityGate {
  VmConnectivityNetworkGateAdapter(this._repository);

  final ConnectivityRepository _repository;

  @override
  bool get isOnline => _repository.current.isOnline;

  @override
  Stream<bool> get onlineChanges =>
      _repository.changes.map((state) => state.isOnline);
}
