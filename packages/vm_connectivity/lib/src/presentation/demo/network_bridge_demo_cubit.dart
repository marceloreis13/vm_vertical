// ignore_for_file: prefer_initializing_formals
// (fields are private while the constructor's named parameters are public,
// so a plain initializing formal isn't available here.)

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vm_network/vm_network.dart';

import '../connectivity/cubit/connectivity_cubit.dart';
import 'network_bridge_demo_state.dart';

/// Drives the example's `vm_network` bridge demonstration: issues a request
/// through the app-registered [VmHttpClient] (wired with the
/// `VmConnectivityNetworkGateAdapter` in `example/lib/main.dart`) and
/// reflects whether it was held offline, then whether it eventually
/// succeeded or failed once resumed.
class NetworkBridgeDemoCubit extends Cubit<NetworkBridgeDemoState> {
  NetworkBridgeDemoCubit({
    required VmHttpClient client,
    required ConnectivityCubit connectivityCubit,
  }) : _client = client,
       _connectivityCubit = connectivityCubit,
       super(const NetworkBridgeDemoState.idle());

  final VmHttpClient _client;
  final ConnectivityCubit _connectivityCubit;

  Future<void> sendRequest() async {
    emit(
      NetworkBridgeDemoState.pending(
        heldOffline: !_connectivityCubit.state.isOnline,
      ),
    );
    final result = await _client.getRaw('/todos/1');
    emit(
      result.when(
        success: (_) => const NetworkBridgeDemoState.succeeded(),
        failure: (failure) => NetworkBridgeDemoState.failed(failure.message),
      ),
    );
  }
}
