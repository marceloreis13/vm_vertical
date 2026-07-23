import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../analytics_demo_cubit.dart';

/// One button per demo action, dispatching the matching
/// [AnalyticsDemoCubit] call. Reads the cubit to dispatch, so it is a
/// Section, not a View — specific to this feature's flow.
class DemoControlsSection extends StatelessWidget {
  const DemoControlsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AnalyticsDemoCubit>();
    final tokens = context.vmTokens;
    return Padding(
      padding: EdgeInsets.all(tokens.spacing.md),
      child: Wrap(
        spacing: tokens.spacing.sm,
        runSpacing: tokens.spacing.sm,
        children: [
          VmButton(label: 'Viewed product', onPressed: cubit.emitViewedProduct),
          VmButton(
            label: 'Checkout started',
            onPressed: cubit.emitCheckoutStarted,
          ),
          VmButton(
            label: 'Set plan property',
            onPressed: cubit.setSamplePlanProperty,
            variant: VmButtonVariant.secondary,
          ),
          VmButton(
            label: 'Set user id',
            onPressed: cubit.setSampleUserId,
            variant: VmButtonVariant.secondary,
          ),
          VmButton(
            label: 'Clear user id',
            onPressed: cubit.clearUserId,
            variant: VmButtonVariant.secondary,
          ),
          VmButton(
            label: 'Reset (logout)',
            onPressed: cubit.resetIdentity,
            variant: VmButtonVariant.text,
          ),
        ],
      ),
    );
  }
}
