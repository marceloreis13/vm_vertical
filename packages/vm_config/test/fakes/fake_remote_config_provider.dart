import 'package:vm_config/vm_config.dart';

/// A hand-written fake [RemoteConfigProvider] whose `fetch()` behavior is
/// fully controlled by the test: returns [nextSnapshot], [nextFailure], or
/// throws [throwOnFetch].
class FakeRemoteConfigProvider implements RemoteConfigProvider {
  ConfigMap? nextSnapshot;
  ConfigFailure? nextFailure;
  Object? throwOnFetch;
  int fetchCount = 0;

  @override
  Future<Result<ConfigMap, ConfigFailure>> fetch() async {
    fetchCount++;
    final error = throwOnFetch;
    if (error != null) throw error;
    final failure = nextFailure;
    if (failure != null) return Err(failure);
    return Success(nextSnapshot ?? const {});
  }
}
