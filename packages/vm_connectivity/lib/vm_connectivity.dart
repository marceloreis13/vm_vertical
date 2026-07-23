/// vm_connectivity: an injectable, observable online/offline module. Hides
/// `connectivity_plus` entirely — consumers depend only on the types
/// exported here — and ships a real bridge into `vm_network`'s connectivity
/// gate, with the dependency inverted so `vm_network` never imports this
/// module.
library;

export 'src/data/di/vm_connectivity_registration.dart';
export 'src/data/fake_connectivity_source.dart';
export 'src/data/live_connectivity_source.dart';
export 'src/data/network_gate_adapter.dart';
export 'src/domain/connection_type.dart';
export 'src/domain/connectivity_repository.dart';
export 'src/domain/connectivity_source.dart';
export 'src/domain/connectivity_state.dart';
export 'src/domain/vm_connectivity_config.dart';
export 'src/presentation/connectivity/cubit/connectivity_cubit.dart';
export 'src/presentation/connectivity/sections/offline_banner_section.dart';
export 'src/presentation/connectivity/views/offline_banner_view.dart';
export 'src/presentation/demo/screen/connectivity_demo_screen.dart';
