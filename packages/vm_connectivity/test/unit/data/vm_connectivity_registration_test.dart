import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_connectivity/vm_connectivity.dart';

void main() {
  late GetIt getIt;

  setUp(() {
    getIt = GetIt.asNewInstance();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('registerVmConnectivityModule', () {
    test('resolves the ConnectivityCubit and ConnectivityRepository', () {
      final source = FakeConnectivitySource();

      registerVmConnectivityModule(
        getIt,
        config: VmConnectivityConfig(source: source),
      );

      expect(getIt<ConnectivityCubit>(), isA<ConnectivityCubit>());
      expect(getIt<ConnectivityRepository>(), isA<ConnectivityRepository>());
    });

    test('the resolved Cubit is driven by exactly the configured source', () {
      final source = FakeConnectivitySource(initial: ConnectionType.none);

      registerVmConnectivityModule(
        getIt,
        config: VmConnectivityConfig(source: source),
      );

      expect(
        getIt<ConnectivityCubit>().state,
        const ConnectivityState.offline(),
      );

      source.goOnline();

      expect(
        getIt<ConnectivityCubit>().stream,
        emits(const ConnectivityState.online(ConnectionType.wifi)),
      );
    });

    test(
      'config is taken from the passed parameter, not a module constant',
      () {
        final first = FakeConnectivitySource(initial: ConnectionType.wifi);
        registerVmConnectivityModule(
          getIt,
          config: VmConnectivityConfig(source: first),
        );

        expect(
          getIt<ConnectivityCubit>().state,
          const ConnectivityState.online(ConnectionType.wifi),
        );
      },
    );
  });
}
