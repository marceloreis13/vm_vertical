import 'connection_type.dart';

/// Injectable seam over the OS connection type. The `connectivity_plus`-
/// backed implementation lives in `lib/src/data/` and is never exported from
/// the barrel — only this abstraction, [FakeConnectivitySource] and
/// `createLiveConnectivitySource` are public, so a fake can replace the real
/// source without changing consumers. Active internet-reachability probing
/// is out of scope this iteration; implementations report only the OS-
/// provided connection type.
abstract class ConnectivitySource {
  const ConnectivitySource();

  /// The connection type as of the last known change.
  ConnectionType get current;

  /// Emits every subsequent connection-type change. Does not replay [current]
  /// on subscription.
  Stream<ConnectionType> get onChange;
}
