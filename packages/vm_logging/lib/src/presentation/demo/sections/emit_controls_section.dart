import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../logging_demo_cubit.dart';

/// One button per demo action, dispatching the matching
/// [LoggingDemoCubit] emit call. Reads the cubit to dispatch, so it is a
/// Section, not a View — specific to this feature's flow.
class EmitControlsSection extends StatelessWidget {
  const EmitControlsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoggingDemoCubit>();
    final tokens = context.vmTokens;
    return Padding(
      padding: EdgeInsets.all(tokens.spacing.md),
      child: Wrap(
        spacing: tokens.spacing.sm,
        runSpacing: tokens.spacing.sm,
        children: [
          VmButton(label: 'Trace', onPressed: cubit.emitTrace),
          VmButton(label: 'Debug', onPressed: cubit.emitDebug),
          VmButton(label: 'Info', onPressed: cubit.emitInfo),
          VmButton(label: 'Warn', onPressed: cubit.emitWarn),
          VmButton(label: 'Error', onPressed: cubit.emitError),
          VmButton(
            label: 'Sensitive data',
            onPressed: cubit.emitSensitive,
            variant: VmButtonVariant.secondary,
          ),
          VmButton(
            label: 'Network request',
            onPressed: cubit.emitNetworkRequest,
            variant: VmButtonVariant.secondary,
          ),
        ],
      ),
    );
  }
}
