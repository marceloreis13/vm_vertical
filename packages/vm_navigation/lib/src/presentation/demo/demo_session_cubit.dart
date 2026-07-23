import 'package:flutter_bloc/flutter_bloc.dart';

/// In-memory logged-in/out toggle for the `vm_navigation` example — no
/// `vm_auth` dependency. Demonstrates the shape an app would give a real
/// auth-backed `RouteGuard`; see `DemoSessionGuard`.
class DemoSessionCubit extends Cubit<bool> {
  DemoSessionCubit() : super(false);

  void toggle() => emit(!state);
}
