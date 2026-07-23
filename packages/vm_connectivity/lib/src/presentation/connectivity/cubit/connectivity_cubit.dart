import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/connectivity_repository.dart';
import '../../../domain/connectivity_state.dart';

/// Emits the current [ConnectivityState] and every subsequent transition
/// from the [ConnectivityRepository], so any module or the UI can watch
/// connectivity via `BlocBuilder`/`context.watch` without touching a stream
/// directly. Seeded with the repository's current state on construction.
class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit(this._repository) : super(_repository.current) {
    _subscription = _repository.changes.listen(emit);
  }

  final ConnectivityRepository _repository;
  late final StreamSubscription<ConnectivityState> _subscription;

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
