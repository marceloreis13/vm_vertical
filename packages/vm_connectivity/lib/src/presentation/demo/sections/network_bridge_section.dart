import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../network_bridge_demo_cubit.dart';
import '../network_bridge_demo_state.dart';

/// Reads `NetworkBridgeDemoCubit` and renders the vm_network bridge
/// scenario: a button that issues a request, held while the fake source
/// reports offline and resumed once it reports online again. Specific to
/// this demo; never promoted or reused elsewhere.
class NetworkBridgeSection extends StatelessWidget {
  const NetworkBridgeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NetworkBridgeDemoCubit>().state;
    final cubit = context.read<NetworkBridgeDemoCubit>();
    final tokens = context.vmTokens;

    return Padding(
      padding: EdgeInsets.all(tokens.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'vm_network bridge',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: tokens.spacing.sm),
          Text(_describe(state)),
          SizedBox(height: tokens.spacing.sm),
          VmButton(label: 'Send request', onPressed: cubit.sendRequest),
        ],
      ),
    );
  }

  static String _describe(NetworkBridgeDemoState state) => switch (state) {
    NetworkBridgeIdle() => 'Idle — send a request to see the gate in action.',
    NetworkBridgePending(:final heldOffline) =>
      heldOffline
          ? 'Held offline — will resume once back online.'
          : 'Sent — awaiting response.',
    NetworkBridgeSucceeded() => 'Succeeded.',
    NetworkBridgeFailed(:final message) => 'Failed: $message',
  };
}
