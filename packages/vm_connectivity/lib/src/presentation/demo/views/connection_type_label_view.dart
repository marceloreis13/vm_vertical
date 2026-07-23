import 'package:flutter/material.dart';

import '../../../domain/connection_type.dart';
import '../../../domain/connectivity_state.dart';

/// Renders a plain label for a [ConnectivityState] — "Online (wifi)" or
/// "Offline". Plain parameters only; reusable outside this demo unchanged.
class ConnectionTypeLabelView extends StatelessWidget {
  const ConnectionTypeLabelView({required this.state, super.key});

  final ConnectivityState state;

  @override
  Widget build(BuildContext context) {
    final label = switch (state) {
      ConnectivityOnline(:final type) => 'Online (${_typeLabel(type)})',
      ConnectivityOffline() => 'Offline',
    };
    return Text(
      label,
      key: const ValueKey('connection_type_label'),
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  static String _typeLabel(ConnectionType type) => switch (type) {
    ConnectionType.wifi => 'wifi',
    ConnectionType.cellular => 'cellular',
    ConnectionType.ethernet => 'ethernet',
    ConnectionType.bluetooth => 'bluetooth',
    ConnectionType.vpn => 'vpn',
    ConnectionType.other => 'other',
    ConnectionType.none => 'none',
  };
}
