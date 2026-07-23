import '../../domain/vm_network_interceptor.dart';

/// Custom interceptor used by the "custom interceptor" demo scenario: adds a
/// header the app itself defines, proving `VmNetworkConfig.customInterceptors`
/// reaches the client without the app ever importing a transport type.
class DemoHeaderInterceptor extends VmNetworkInterceptor {
  const DemoHeaderInterceptor();

  @override
  Future<void> onRequest(VmRequestContext request) async {
    request.headers['X-Vm-Demo-Header'] = 'custom-interceptor';
  }
}
