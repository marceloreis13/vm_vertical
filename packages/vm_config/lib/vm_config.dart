/// vm_config: an injectable, source-agnostic configuration module.
/// Consumers depend on the `ConfigReader` interface only — the consuming
/// app decides the remote provider, defaults, environment and optional
/// cache via `registerVmConfigModule`. No vendor SDK type or `vm_storage`
/// dependency appears in the public API.
library;

export 'src/core/config_failure.dart';
export 'src/core/result.dart';
export 'src/core/unit.dart';
export 'src/data/cache/in_memory_config_cache.dart';
export 'src/data/di/vm_config_registration.dart';
export 'src/data/providers/local_config_provider.dart';
export 'src/data/providers/static_map_config_provider.dart';
export 'src/domain/config_cache.dart';
export 'src/domain/config_change.dart';
export 'src/domain/config_map.dart';
export 'src/domain/config_reader.dart';
export 'src/domain/remote_config_provider.dart';
export 'src/domain/vm_config_config.dart';
export 'src/domain/vm_environment.dart';
export 'src/presentation/demo/screen/config_demo_screen.dart';
