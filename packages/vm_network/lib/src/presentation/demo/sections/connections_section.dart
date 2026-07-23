import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../network_demo_cubit.dart';
import '../scenario_result.dart';
import '../views/scenario_card_view.dart';

/// Successful connection styles: direct public API, Basic auth, bearer
/// token (via the auth interceptor), and a custom interceptor's effect.
class ConnectionsSection extends StatelessWidget {
  const ConnectionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NetworkDemoCubit>();
    return BlocBuilder<NetworkDemoCubit, Map<String, ScenarioResult>>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ScenarioCardView(
              title: 'Direct public API',
              description: 'GET /get — no authentication',
              buttonLabel: 'Run',
              result: state[DemoScenario.direct]!,
              onPressed: cubit.runDirect,
            ),
            const SizedBox(height: 12),
            ScenarioCardView(
              title: 'Basic auth',
              description: 'GET /basic-auth/demo/demo123 with credentials',
              buttonLabel: 'Run',
              result: state[DemoScenario.basicAuthOk]!,
              onPressed: cubit.runBasicAuthOk,
            ),
            const SizedBox(height: 12),
            ScenarioCardView(
              title: 'Bearer token',
              description:
                  'GET /bearer — token attached by the auth interceptor',
              buttonLabel: 'Run',
              result: state[DemoScenario.bearer]!,
              onPressed: cubit.runBearer,
            ),
            const SizedBox(height: 12),
            ScenarioCardView(
              title: 'Custom interceptor',
              description:
                  'GET /get — a consumer-registered interceptor adds a '
                  'header, echoed back by the server',
              buttonLabel: 'Run',
              result: state[DemoScenario.customInterceptor]!,
              onPressed: cubit.runCustomInterceptor,
            ),
          ],
        );
      },
    );
  }
}
