import 'package:get_it/get_it.dart';

import '../../domain/vm_http_client.dart';
import '../../domain/vm_network_config.dart';
import '../vm_dio_http_client.dart';

/// Single registration entry point for `vm_network`. Receives its
/// [config] from the consuming app — nothing here is hard-coded.
///
/// Interceptor chain order: auth -> default headers -> custom (in supplied
/// order) -> retry -> logging.
void registerVmNetworkModule(GetIt getIt, {required VmNetworkConfig config}) {
  getIt.registerSingleton<VmNetworkConfig>(config);
  getIt.registerSingleton<VmHttpClient>(VmDioHttpClient.fromConfig(config));
}
