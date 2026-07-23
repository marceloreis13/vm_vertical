import 'package:flutter_test/flutter_test.dart';
import 'package:vm_connectivity/src/data/connectivity_repository_impl.dart';
import 'package:vm_connectivity/vm_connectivity.dart';

void main() {
  group('ConnectivityRepositoryImpl', () {
    test('current derives from the source and none maps to Offline', () {
      final source = FakeConnectivitySource(initial: ConnectionType.none);
      final repository = ConnectivityRepositoryImpl(source);

      expect(repository.current, const ConnectivityState.offline());
      expect(repository.current.isOnline, isFalse);
    });

    test('current derives from the source for a connected type', () {
      final source = FakeConnectivitySource(initial: ConnectionType.wifi);
      final repository = ConnectivityRepositoryImpl(source);

      expect(
        repository.current,
        const ConnectivityState.online(ConnectionType.wifi),
      );
      expect(repository.current.isOnline, isTrue);
    });

    test(
      'changes reflects online -> offline -> online transitions in order',
      () {
        final source = FakeConnectivitySource(initial: ConnectionType.wifi);
        final repository = ConnectivityRepositoryImpl(source);

        expect(
          repository.changes,
          emitsInOrder([
            const ConnectivityState.offline(),
            const ConnectivityState.online(ConnectionType.cellular),
          ]),
        );

        source.goOffline();
        source.goOnline(ConnectionType.cellular);
      },
    );
  });
}
