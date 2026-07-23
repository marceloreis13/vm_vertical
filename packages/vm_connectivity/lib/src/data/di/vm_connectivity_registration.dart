import 'package:get_it/get_it.dart';

import '../../domain/connectivity_repository.dart';
import '../../domain/vm_connectivity_config.dart';
import '../../presentation/connectivity/cubit/connectivity_cubit.dart';
import '../connectivity_repository_impl.dart';

/// Single registration entry point for `vm_connectivity`. Receives its
/// [config] from the consuming app — the source (real or fake) and any
/// tuning are never hard-coded inside the module. Registers the repository
/// and the `ConnectivityCubit` consumers resolve by their public types.
void registerVmConnectivityModule(
  GetIt getIt, {
  required VmConnectivityConfig config,
}) {
  getIt.registerSingleton<VmConnectivityConfig>(config);

  final repository = ConnectivityRepositoryImpl(
    config.source,
    debounce: config.debounce,
  );
  getIt.registerSingleton<ConnectivityRepository>(repository);
  getIt.registerSingleton<ConnectivityCubit>(ConnectivityCubit(repository));
}
