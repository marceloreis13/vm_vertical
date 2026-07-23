import 'package:flutter_test/flutter_test.dart';
import 'package:vm_connectivity/src/data/connectivity_repository_impl.dart';
import 'package:vm_connectivity/vm_connectivity.dart';

void main() {
  group('VmConnectivityNetworkGateAdapter', () {
    test('isOnline reflects the repository current state', () {
      final source = FakeConnectivitySource(initial: ConnectionType.wifi);
      final adapter = VmConnectivityNetworkGateAdapter(
        ConnectivityRepositoryImpl(source),
      );

      expect(adapter.isOnline, isTrue);

      source.goOffline();

      expect(adapter.isOnline, isFalse);
    });

    test(
      'onlineChanges emits true/false matching isOnline as the state transitions',
      () {
        final source = FakeConnectivitySource(initial: ConnectionType.wifi);
        final adapter = VmConnectivityNetworkGateAdapter(
          ConnectivityRepositoryImpl(source),
        );

        expect(adapter.onlineChanges, emitsInOrder([false, true]));

        source.goOffline();
        source.goOnline(ConnectionType.cellular);
      },
    );
  });
}
