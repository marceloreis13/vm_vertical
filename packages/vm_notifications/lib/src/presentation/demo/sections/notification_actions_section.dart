import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../notification_demo_cubit.dart';
import '../notification_demo_state.dart';

/// Reads [NotificationDemoState] and renders the demo's controls: schedule
/// a local notification, simulate an incoming push, and tap the last
/// received one to exercise the injected `NotificationRouter`. Specific to
/// this feature; never promoted or reused elsewhere.
class NotificationActionsSection extends StatelessWidget {
  const NotificationActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NotificationDemoCubit>().state;
    final cubit = context.read<NotificationDemoCubit>();
    final tokens = context.vmTokens;

    return Padding(
      padding: EdgeInsets.all(tokens.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Push token: ${state.token ?? 'unset'}'),
          SizedBox(height: tokens.spacing.sm),
          if (state.lastFailure != null) ...[
            VmBanner(message: state.lastFailure!),
            SizedBox(height: tokens.spacing.sm),
          ],
          Wrap(
            spacing: tokens.spacing.sm,
            runSpacing: tokens.spacing.sm,
            children: [
              VmButton(label: 'Schedule local', onPressed: cubit.scheduleLocal),
              VmButton(
                label: 'Simulate push',
                onPressed: cubit.simulatePush,
                variant: VmButtonVariant.secondary,
              ),
              VmButton(
                label: 'Tap last received',
                onPressed: state.receivedLog.isEmpty
                    ? null
                    : cubit.tapLastReceived,
                variant: VmButtonVariant.text,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
