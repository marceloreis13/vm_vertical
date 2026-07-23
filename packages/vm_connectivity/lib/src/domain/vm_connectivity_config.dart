import 'connectivity_source.dart';

/// Configuration for `vm_connectivity`, always supplied by the consuming app
/// via `registerVmConnectivityModule`. The module never hard-codes a source
/// or reads ambient/global state — the source (real or fake) always comes
/// from here.
class VmConnectivityConfig {
  const VmConnectivityConfig({required this.source, this.debounce});

  /// The connectivity source driving the observable state. Use
  /// `createLiveConnectivitySource()` for the real `connectivity_plus`-backed
  /// source, or a `FakeConnectivitySource` for tests/examples.
  final ConnectivitySource source;

  /// When set, smooths rapid online/offline flapping by only emitting a
  /// transition after it has been stable for this long. `null` (the default)
  /// emits every transition immediately.
  final Duration? debounce;
}
