import '../core/config_failure.dart';
import '../core/result.dart';
import 'config_map.dart';

/// The pull-based port every concrete remote config source implements. An
/// app binds a real vendor SDK (Firebase Remote Config, LaunchDarkly, ...)
/// behind this port and injects it via `VmConfigConfig.provider`.
/// `vm_config` never imports a concrete remote SDK; providers translate
/// their SDK to this port. See `config-providers`.
abstract interface class RemoteConfigProvider {
  /// Fetches the current remote key/value snapshot. A failure (including an
  /// unexpected throw) SHALL be represented as a [ConfigFailure], never
  /// propagated as a raw exception.
  Future<Result<ConfigMap, ConfigFailure>> fetch();
}
