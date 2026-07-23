import 'package:get_it/get_it.dart';

import '../../domain/config_reader.dart';
import '../../domain/vm_config_config.dart';
import '../debug/config_debug_log.dart';
import '../resolution/config_resolution_engine.dart';
import '../vm_config_reader.dart';

/// Single registration entry point for `vm_config`. Receives its [config]
/// from the consuming app — no provider, key, default, environment or env
/// object is hard-coded inside the module. Registers the resolution engine
/// (resolving defaults/cache synchronously) and the [ConfigReader]
/// consumers depend on.
void registerVmConfigModule(GetIt getIt, {required VmConfigConfig config}) {
  getIt.registerSingleton<VmConfigConfig>(config);

  const debugLog = DeveloperConfigDebugLog();
  final engine = ConfigResolutionEngine(
    defaults: config.defaults,
    cache: config.cache,
    debugLog: debugLog,
  );
  getIt.registerSingleton<ConfigResolutionEngine>(engine);

  getIt.registerSingleton<ConfigReader>(
    VmConfigReaderImpl(
      provider: config.provider,
      engine: engine,
      environment: config.environment,
      envObject: config.env,
      debugLog: debugLog,
    ),
  );
}
