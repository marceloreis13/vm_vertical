import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_bridge_demo_state.freezed.dart';

/// State of the demo's `vm_network` bridge scenario: a request that may be
/// held offline by the gate before being resumed and attempted.
@freezed
sealed class NetworkBridgeDemoState with _$NetworkBridgeDemoState {
  const factory NetworkBridgeDemoState.idle() = NetworkBridgeIdle;

  /// Dispatched: [heldOffline] records whether the gate was offline at the
  /// moment the request was issued (i.e. it will be held until the source
  /// goes back online, or the policy bound is exceeded).
  const factory NetworkBridgeDemoState.pending({required bool heldOffline}) =
      NetworkBridgePending;

  const factory NetworkBridgeDemoState.succeeded() = NetworkBridgeSucceeded;

  const factory NetworkBridgeDemoState.failed(String message) =
      NetworkBridgeFailed;
}
