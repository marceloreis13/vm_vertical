import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../data/fake_connectivity_source.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../views/connection_type_label_view.dart';

/// Reads `ConnectivityCubit` and renders the demo's status label plus the
/// manual online/offline toggle driving the injected
/// [FakeConnectivitySource]. Specific to this demo; never promoted or
/// reused elsewhere.
class ConnectivityStatusSection extends StatelessWidget {
  const ConnectivityStatusSection({required this.fakeSource, super.key});

  final FakeConnectivitySource fakeSource;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ConnectivityCubit>().state;
    final tokens = context.vmTokens;

    return Padding(
      padding: EdgeInsets.all(tokens.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConnectionTypeLabelView(state: state),
          SizedBox(height: tokens.spacing.sm),
          Wrap(
            spacing: tokens.spacing.sm,
            runSpacing: tokens.spacing.sm,
            children: [
              VmButton(label: 'Go online', onPressed: fakeSource.goOnline),
              VmButton(
                label: 'Go offline',
                onPressed: fakeSource.goOffline,
                variant: VmButtonVariant.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
