import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../domain/analytics_call.dart';
import '../analytics_demo_cubit.dart';
import '../views/analytics_call_tile_view.dart';

/// Renders the live list of calls the demo has received so far, newest
/// first, reading [AnalyticsDemoCubit]'s state directly — a Section, not a
/// View.
class AnalyticsCallListSection extends StatelessWidget {
  const AnalyticsCallListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsDemoCubit, List<AnalyticsCall>>(
      builder: (context, calls) {
        if (calls.isEmpty) {
          return const VmEmptyView(
            message:
                'No analytics calls yet. Tap a button above or navigate to '
                'the details screen.',
          );
        }
        final tokens = context.vmTokens;
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: tokens.spacing.md),
          itemCount: calls.length,
          separatorBuilder: (_, _) => SizedBox(height: tokens.spacing.sm),
          itemBuilder: (context, index) =>
              AnalyticsCallTileView(call: calls[calls.length - 1 - index]),
        );
      },
    );
  }
}
