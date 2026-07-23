import 'connectivity_state.dart';

/// Observes a [ConnectivitySource] and exposes it in domain terms as a
/// [ConnectivityState]. Implemented in `data/`, consumed by the
/// `ConnectivityCubit`.
abstract class ConnectivityRepository {
  /// The current state, derived from the source's present value.
  ConnectivityState get current;

  /// Every subsequent state transition. Does not replay [current] on
  /// subscription.
  Stream<ConnectivityState> get changes;
}
