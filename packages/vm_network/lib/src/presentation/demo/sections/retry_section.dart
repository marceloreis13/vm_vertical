import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../network_demo_cubit.dart';
import '../scenario_result.dart';
import '../views/scenario_card_view.dart';

/// Retry/backoff in action: a client configured to treat 500 as transient
/// retries `/status/500` up to its policy's max attempts before surfacing
/// the final typed failure.
class RetrySection extends StatelessWidget {
  const RetrySection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NetworkDemoCubit>();
    return BlocBuilder<NetworkDemoCubit, Map<String, ScenarioResult>>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ScenarioCardView(
              title: 'Retry on 500',
              description:
                  'GET /status/500 against a client whose RetryPolicy '
                  'treats 500 as retriable (3 attempts, backoff between '
                  'each). httpbin always returns 500, so this demonstrates '
                  'retries exhausting before the final typed failure.',
              buttonLabel: 'Run',
              result: state[DemoScenario.retry]!,
              onPressed: cubit.runRetry,
            ),
          ],
        );
      },
    );
  }
}
