import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vm_connectivity/src/data/connectivity_repository_impl.dart';
import 'package:vm_connectivity/vm_connectivity.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

void main() {
  Widget buildApp(ConnectivityCubit cubit) {
    final theme = buildVmTheme(
      tokens: VmThemeTokens.standard(),
      palette: VmColorPalette.mock(),
    );
    return MaterialApp(
      theme: theme.light,
      home: BlocProvider.value(
        value: cubit,
        child: const Scaffold(body: OfflineBannerSection()),
      ),
    );
  }

  testWidgets('banner is hidden while the state is Online', (tester) async {
    final source = FakeConnectivitySource(initial: ConnectionType.wifi);
    final cubit = ConnectivityCubit(ConnectivityRepositoryImpl(source));
    addTearDown(cubit.close);

    await tester.pumpWidget(buildApp(cubit));
    await tester.pump();

    expect(find.byType(OfflineBannerView), findsNothing);
  });

  testWidgets('banner is shown while the state is Offline', (tester) async {
    final source = FakeConnectivitySource(initial: ConnectionType.none);
    final cubit = ConnectivityCubit(ConnectivityRepositoryImpl(source));
    addTearDown(cubit.close);

    await tester.pumpWidget(buildApp(cubit));
    await tester.pump();

    expect(find.byType(OfflineBannerView), findsOneWidget);
  });

  testWidgets('banner hides once the state transitions to Online', (
    tester,
  ) async {
    final source = FakeConnectivitySource(initial: ConnectionType.none);
    final cubit = ConnectivityCubit(ConnectivityRepositoryImpl(source));
    addTearDown(cubit.close);

    await tester.pumpWidget(buildApp(cubit));
    await tester.pump();
    expect(find.byType(OfflineBannerView), findsOneWidget);

    source.goOnline();
    await tester.pump();
    await tester.pump();

    expect(find.byType(OfflineBannerView), findsNothing);
  });
}
