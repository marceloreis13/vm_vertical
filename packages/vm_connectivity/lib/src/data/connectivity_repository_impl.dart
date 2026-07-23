// ignore_for_file: prefer_initializing_formals
// (the field is private while the named constructor parameter is public
// `debounce`, so a plain initializing formal isn't available here.)

import '../domain/connection_type.dart';
import '../domain/connectivity_repository.dart';
import '../domain/connectivity_source.dart';
import '../domain/connectivity_state.dart';
import 'debounced_stream.dart';

/// Maps a [ConnectivitySource] onto [ConnectivityState]. `none` always maps
/// to [ConnectivityOffline]; every other [ConnectionType] maps to
/// [ConnectivityOnline].
class ConnectivityRepositoryImpl implements ConnectivityRepository {
  ConnectivityRepositoryImpl(this._source, {Duration? debounce})
    : _debounce = debounce;

  final ConnectivitySource _source;
  final Duration? _debounce;

  @override
  ConnectivityState get current => _map(_source.current);

  @override
  Stream<ConnectivityState> get changes {
    final mapped = _source.onChange.map(_map);
    final debounce = _debounce;
    return debounce == null ? mapped : mapped.debounced(debounce);
  }

  static ConnectivityState _map(ConnectionType type) =>
      type == ConnectionType.none
      ? const ConnectivityState.offline()
      : ConnectivityState.online(type);
}
