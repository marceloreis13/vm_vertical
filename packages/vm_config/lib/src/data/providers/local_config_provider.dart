import '../../core/config_failure.dart';
import '../../core/result.dart';
import '../../domain/config_map.dart';
import '../../domain/remote_config_provider.dart';

/// Built-in inert [RemoteConfigProvider]: it contributes no remote values,
/// so the reader serves only the injected defaults (and cache, if any).
/// The default choice for tests and standalone use. See `config-providers`.
class LocalConfigProvider implements RemoteConfigProvider {
  const LocalConfigProvider();

  @override
  Future<Result<ConfigMap, ConfigFailure>> fetch() async =>
      const Success(<String, Object?>{});
}
