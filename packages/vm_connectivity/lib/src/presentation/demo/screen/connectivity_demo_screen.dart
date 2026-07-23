import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_network/vm_network.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../data/fake_connectivity_source.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../connectivity/sections/offline_banner_section.dart';
import '../network_bridge_demo_cubit.dart';
import '../sections/connectivity_status_section.dart';
import '../sections/network_bridge_section.dart';

/// Entry point of the `vm_connectivity` visual example. Resolves the
/// app-registered `ConnectivityCubit`/`VmHttpClient` (via
/// `registerVmConnectivityModule`/`registerVmNetworkModule`) and takes the
/// same [fakeSource] instance the app registered so the demo can toggle
/// online/offline directly. Lives in `lib/`, not `example/`, so any app can
/// embed it directly (see `docs/module-scaffold.md`).
class ConnectivityDemoScreen extends StatelessWidget {
  const ConnectivityDemoScreen({
    required this.fakeSource,
    this.getIt,
    super.key,
  });

  final FakeConnectivitySource fakeSource;

  /// Defaults to [GetIt.instance]; overridable for tests/embedding apps
  /// with a scoped container.
  final GetIt? getIt;

  @override
  Widget build(BuildContext context) {
    final container = getIt ?? GetIt.instance;
    final connectivityCubit = container<ConnectivityCubit>();
    final httpClient = container<VmHttpClient>();

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: connectivityCubit),
        BlocProvider(
          create: (_) => NetworkBridgeDemoCubit(
            client: httpClient,
            connectivityCubit: connectivityCubit,
          ),
        ),
      ],
      child: Scaffold(
        appBar: const VmAppBar(title: 'vm_connectivity example'),
        body: Column(
          children: [
            const OfflineBannerSection(),
            ConnectivityStatusSection(fakeSource: fakeSource),
            const Divider(height: 1),
            const Expanded(child: NetworkBridgeSection()),
          ],
        ),
      ),
    );
  }
}
