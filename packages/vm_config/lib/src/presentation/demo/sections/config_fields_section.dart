import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../config_demo_cubit.dart';
import '../config_demo_state.dart';
import '../views/config_field_tile_view.dart';

/// Reads [ConfigDemoState] and renders one [ConfigFieldTileView] per demoed
/// key, wiring each row's action to the right `ConfigDemoCubit` method.
/// Specific to this feature; never promoted or reused elsewhere.
class ConfigFieldsSection extends StatelessWidget {
  const ConfigFieldsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ConfigDemoCubit>().state;
    if (state.fields.isEmpty) {
      return const VmLoadingView();
    }
    final cubit = context.read<ConfigDemoCubit>();
    final tokens = context.vmTokens;
    return ListView.separated(
      padding: EdgeInsets.all(tokens.spacing.md),
      itemCount: state.fields.length,
      separatorBuilder: (_, _) => SizedBox(height: tokens.spacing.sm),
      itemBuilder: (context, index) {
        final field = state.fields[index];
        return ConfigFieldTileView(
          label: field.label,
          defaultDisplay: '${field.defaultValue ?? 'unset'}',
          cacheDisplay: '${field.cacheValue ?? 'unset'}',
          remoteDisplay: '${field.remoteValue ?? 'unset'}',
          resolvedDisplay: '${field.resolvedValue}',
          action: _actionFor(field.key, field.remoteValue, cubit),
          onClearRemote: () => cubit.clearRemote(field.key),
        );
      },
    );
  }

  Widget _actionFor(String key, Object? remoteValue, ConfigDemoCubit cubit) {
    switch (key) {
      case 'new_checkout':
        return Switch.adaptive(
          value: remoteValue as bool? ?? false,
          onChanged: (_) => cubit.toggleNewCheckout(),
        );
      case 'max_items':
        return VmButton(label: 'Cycle', onPressed: cubit.cycleMaxItems);
      case 'theme':
        return VmButton(label: 'Cycle', onPressed: cubit.cycleTheme);
      default:
        return const SizedBox.shrink();
    }
  }
}
