import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../navigation/domain/vm_navigator_service.dart';
import '../demo_navigation_cubit.dart';

/// Screen 3: navigation triggered from [DemoNavigationCubit], which calls
/// [VmNavigatorService] directly with no `BuildContext`.
class DemoCubitNavScreen extends StatelessWidget {
  const DemoCubitNavScreen({this.getIt, super.key});

  final GetIt? getIt;

  @override
  Widget build(BuildContext context) {
    final container = getIt ?? GetIt.instance;
    final tokens = context.vmTokens;

    return BlocProvider(
      create: (_) => DemoNavigationCubit(container<VmNavigatorService>()),
      child: Scaffold(
        appBar: const VmAppBar(title: 'Cubit-driven navigation'),
        body: Padding(
          padding: EdgeInsets.all(tokens.spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VmCard(
                child: Text(
                  'Tapping the button below calls DemoNavigationCubit, '
                  'which navigates home via VmNavigatorService — no '
                  'BuildContext involved.',
                ),
              ),
              SizedBox(height: tokens.spacing.md),
              BlocBuilder<DemoNavigationCubit, int>(
                builder: (context, navigationCount) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Navigated home $navigationCount time(s) via Cubit.'),
                    SizedBox(height: tokens.spacing.sm),
                    VmButton(
                      label: 'Go Home via Cubit',
                      onPressed: () =>
                          context.read<DemoNavigationCubit>().goHome(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
