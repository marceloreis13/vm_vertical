import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../notification_demo_cubit.dart';
import '../notification_demo_state.dart';
import '../views/notification_log_tile_view.dart';

/// Reads [NotificationDemoState] and renders the log of received/simulated
/// notifications, one [NotificationLogTileView] per entry. Specific to this
/// feature; never promoted or reused elsewhere.
class NotificationLogSection extends StatelessWidget {
  const NotificationLogSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NotificationDemoCubit>().state;
    if (state.receivedLog.isEmpty) {
      return const VmEmptyView(message: 'No notifications yet');
    }
    final tokens = context.vmTokens;
    return ListView.separated(
      padding: EdgeInsets.all(tokens.spacing.md),
      itemCount: state.receivedLog.length,
      separatorBuilder: (_, _) => SizedBox(height: tokens.spacing.sm),
      itemBuilder: (context, index) {
        return NotificationLogTileView(payload: state.receivedLog[index]);
      },
    );
  }
}
