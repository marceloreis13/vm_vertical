import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../data/vm_dio_http_client.dart';
import '../../../domain/retry_policy.dart';
import '../../../domain/vm_http_client.dart';
import '../../../domain/vm_network_config.dart';
import '../network_demo_cubit.dart';
import '../sections/connections_section.dart';
import '../sections/errors_section.dart';
import '../sections/retry_section.dart';

/// Entry point of the `vm_network` visual example. Resolves the
/// app-registered [VmHttpClient] (via `registerVmNetworkModule`) for every
/// scenario that only needs the base config, and builds two additional
/// clients locally — a short-timeout one and a retry-on-500 one — so the
/// timeout and retry demos have real, distinct behavior to show. Lives in
/// `lib/`, not `example/`, so any app can embed it directly (see
/// `docs/module-scaffold.md`).
class NetworkDemoScreen extends StatelessWidget {
  const NetworkDemoScreen({this.getIt, super.key});

  /// Defaults to [GetIt.instance]; overridable for tests/embedding apps
  /// with a scoped container.
  final GetIt? getIt;

  static const _tabs = ['Connections', 'Errors', 'Retry'];

  @override
  Widget build(BuildContext context) {
    final container = getIt ?? GetIt.instance;
    final baseConfig = container<VmNetworkConfig>();
    final sharedClient = container<VmHttpClient>();

    final timeoutClient = VmDioHttpClient.fromConfig(
      VmNetworkConfig(
        baseUrl: baseConfig.baseUrl,
        receiveTimeout: const Duration(seconds: 1),
        retryPolicy: const RetryPolicy.none(),
      ),
    );
    final retryClient = VmDioHttpClient.fromConfig(
      VmNetworkConfig(
        baseUrl: baseConfig.baseUrl,
        retryPolicy: const RetryPolicy(
          maxAttempts: 3,
          retriableStatusCodes: {500},
        ),
      ),
    );

    return BlocProvider(
      create: (_) => NetworkDemoCubit(
        sharedClient: sharedClient,
        timeoutClient: timeoutClient,
        retryClient: retryClient,
      ),
      child: DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: VmAppBar(
            title: 'vm_network example',
            bottom: TabBar(tabs: [for (final tab in _tabs) Tab(text: tab)]),
          ),
          body: const TabBarView(
            children: [ConnectionsSection(), ErrorsSection(), RetrySection()],
          ),
        ),
      ),
    );
  }
}
