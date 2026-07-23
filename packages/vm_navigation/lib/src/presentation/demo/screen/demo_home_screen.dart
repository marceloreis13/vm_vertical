import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../navigation/domain/vm_navigator_service.dart';
import '../demo_routes.dart';
import '../demo_session_cubit.dart';

/// Screen 1 of the `vm_navigation` example: a local in-memory logged-in/out
/// toggle, and entry points to the guarded and Cubit-driven demo screens.
class DemoHomeScreen extends StatelessWidget {
  const DemoHomeScreen({this.getIt, super.key});

  /// Defaults to [GetIt.instance]; overridable for tests/embedding apps
  /// with a scoped container.
  final GetIt? getIt;

  @override
  Widget build(BuildContext context) {
    final container = getIt ?? GetIt.instance;
    final session = container<DemoSessionCubit>();
    final navigator = container<VmNavigatorService>();
    final tokens = context.vmTokens;

    return Scaffold(
      appBar: const VmAppBar(title: 'vm_navigation example'),
      body: Padding(
        padding: EdgeInsets.all(tokens.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VmCard(
              child: BlocBuilder<DemoSessionCubit, bool>(
                bloc: session,
                builder: (context, isLoggedIn) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: tokens.spacing.sm),
                    VmSegmentedControl<bool>(
                      segments: const [
                        VmSegment(value: false, label: 'Logged out'),
                        VmSegment(value: true, label: 'Logged in'),
                      ],
                      selected: isLoggedIn,
                      onChanged: (_) => session.toggle(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: tokens.spacing.md),
            VmButton(
              label: 'Go to protected route',
              onPressed: () => navigator.go(const DemoProtectedRoute()),
            ),
            SizedBox(height: tokens.spacing.sm),
            VmButton(
              label: 'Go to Cubit-driven navigation',
              variant: VmButtonVariant.secondary,
              onPressed: () => navigator.go(const DemoCubitNavRoute()),
            ),
          ],
        ),
      ),
    );
  }
}
