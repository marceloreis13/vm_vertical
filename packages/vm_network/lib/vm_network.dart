/// vm_network: a generic, injectable HTTP client with typed results and a
/// standardized failure taxonomy. Hides the underlying transport (Dio)
/// entirely — consumers depend only on the types exported here.
library;

export 'src/core/failure.dart';
export 'src/core/json_map.dart';
export 'src/core/result.dart';
export 'src/data/di/vm_network_registration.dart';
export 'src/domain/offline_request_policy.dart';
export 'src/domain/retry_policy.dart';
export 'src/domain/vm_connectivity_gate.dart';
export 'src/domain/vm_http_client.dart';
export 'src/domain/vm_network_config.dart';
export 'src/domain/vm_network_interceptor.dart';
export 'src/presentation/demo/demo_header_interceptor.dart';
export 'src/presentation/demo/screen/network_demo_screen.dart';
