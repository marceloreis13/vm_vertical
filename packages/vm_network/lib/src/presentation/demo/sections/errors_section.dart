import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../network_demo_cubit.dart';
import '../scenario_result.dart';
import '../views/scenario_card_view.dart';

/// Explicit typed-failure scenarios: server errors (404/500), unauthorized
/// (401), and a timeout.
class ErrorsSection extends StatelessWidget {
  const ErrorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NetworkDemoCubit>();
    return BlocBuilder<NetworkDemoCubit, Map<String, ScenarioResult>>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ScenarioCardView(
              title: 'Not found (404)',
              description: 'GET /status/404',
              buttonLabel: 'Run',
              result: state[DemoScenario.notFound]!,
              onPressed: cubit.runNotFound,
            ),
            const SizedBox(height: 12),
            ScenarioCardView(
              title: 'Server error (500)',
              description: 'GET /status/500',
              buttonLabel: 'Run',
              result: state[DemoScenario.serverError]!,
              onPressed: cubit.runServerError,
            ),
            const SizedBox(height: 12),
            ScenarioCardView(
              title: 'Unauthorized (401)',
              description:
                  'GET /basic-auth/demo/demo123 with the wrong password',
              buttonLabel: 'Run',
              result: state[DemoScenario.unauthorized]!,
              onPressed: cubit.runUnauthorized,
            ),
            const SizedBox(height: 12),
            ScenarioCardView(
              title: 'Timeout',
              description:
                  'GET /delay/3 against a client configured with a 1s '
                  'receive timeout',
              buttonLabel: 'Run',
              result: state[DemoScenario.timeout]!,
              onPressed: cubit.runTimeout,
            ),
          ],
        );
      },
    );
  }
}
