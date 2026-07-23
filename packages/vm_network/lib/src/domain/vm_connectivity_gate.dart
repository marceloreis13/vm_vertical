/// `vm_network`'s own abstract online/offline signal — an injectable seam
/// the module never wires to a concrete implementation itself. `vm_network`
/// does not import `vm_connectivity` or any concrete connectivity package;
/// the consuming app supplies whatever online signal it has (e.g.
/// `vm_connectivity`'s adapter) via `VmNetworkConfig.gate`. When no gate is
/// configured, the client behaves exactly as before (no offline gating).
abstract class VmConnectivityGate {
  const VmConnectivityGate();

  /// Whether the app is currently online, as of the last known change.
  bool get isOnline;

  /// Emits every subsequent online/offline transition.
  Stream<bool> get onlineChanges;
}
