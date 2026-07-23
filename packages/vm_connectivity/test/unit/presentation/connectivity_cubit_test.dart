import 'package:flutter_test/flutter_test.dart';
import 'package:vm_connectivity/src/data/connectivity_repository_impl.dart';
import 'package:vm_connectivity/vm_connectivity.dart';

void main() {
  group('ConnectivityCubit', () {
    test('initial state is derived from the source current value', () {
      final source = FakeConnectivitySource(initial: ConnectionType.wifi);
      final cubit = ConnectivityCubit(ConnectivityRepositoryImpl(source));
      addTearDown(cubit.close);

      expect(cubit.state, const ConnectivityState.online(ConnectionType.wifi));
    });

    test('none maps to Offline as the initial state', () {
      final source = FakeConnectivitySource(initial: ConnectionType.none);
      final cubit = ConnectivityCubit(ConnectivityRepositoryImpl(source));
      addTearDown(cubit.close);

      expect(cubit.state, const ConnectivityState.offline());
    });

    test('emits every subsequent transition: online -> offline -> online', () {
      final source = FakeConnectivitySource(initial: ConnectionType.wifi);
      final cubit = ConnectivityCubit(ConnectivityRepositoryImpl(source));
      addTearDown(cubit.close);

      expect(
        cubit.stream,
        emitsInOrder([
          const ConnectivityState.offline(),
          const ConnectivityState.online(ConnectionType.cellular),
        ]),
      );

      source.goOffline();
      source.goOnline(ConnectionType.cellular);
    });
  });
}
