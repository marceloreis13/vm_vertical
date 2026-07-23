import '../domain/connectivity_source.dart';
import 'connectivity_plus_source.dart';

/// The module's single "injectable default wiring" entry point: the only
/// place a concrete platform connectivity source is instantiated. Returns
/// the [ConnectivitySource] abstraction — no `connectivity_plus` type is
/// exposed. Pass the result as `VmConnectivityConfig.source` to drive the
/// module from the real OS connection type.
ConnectivitySource createLiveConnectivitySource() => ConnectivityPlusSource();
