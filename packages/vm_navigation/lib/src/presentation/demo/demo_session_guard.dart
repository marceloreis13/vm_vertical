import '../../guards/domain/route_guard.dart';
import 'demo_session_cubit.dart';

/// Example [RouteGuard]: passes while [DemoSessionCubit] reports "logged
/// in". Stands in for a real auth/feature-flag predicate an app would
/// supply — `vm_navigation` itself never imports `vm_auth`/`vm_config`.
class DemoSessionGuard extends RouteGuard {
  const DemoSessionGuard(this._session);

  final DemoSessionCubit _session;

  @override
  bool evaluate() => _session.state;
}
