import 'package:freezed_annotation/freezed_annotation.dart';

import 'connection_type.dart';

part 'connectivity_state.freezed.dart';

/// Sealed connectivity state: online with the connection [ConnectionType], or
/// offline. `ConnectionType.none` always maps to [ConnectivityOffline] — see
/// `ConnectivityRepository`.
@freezed
sealed class ConnectivityState with _$ConnectivityState {
  const ConnectivityState._();

  const factory ConnectivityState.online(ConnectionType type) =
      ConnectivityOnline;

  const factory ConnectivityState.offline() = ConnectivityOffline;

  /// `true` while [ConnectivityOnline], `false` while [ConnectivityOffline].
  bool get isOnline => switch (this) {
    ConnectivityOnline() => true,
    ConnectivityOffline() => false,
  };
}
