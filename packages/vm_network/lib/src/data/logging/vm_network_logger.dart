import 'dart:developer' as developer;

/// Thin logging seam so the client never calls `dart:developer` directly.
/// `vm_logging` can later back this interface without touching the client.
abstract class VmNetworkLogger {
  void log(String message);
}

class DeveloperVmNetworkLogger implements VmNetworkLogger {
  const DeveloperVmNetworkLogger();

  @override
  void log(String message) => developer.log(message, name: 'vm_network');
}
