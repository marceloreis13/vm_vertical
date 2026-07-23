import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../key_value_demo_cubit.dart';

/// Preferences CRUD demo, reading `KeyValueDemoState`.
class KeyValueSection extends StatefulWidget {
  const KeyValueSection({super.key});

  @override
  State<KeyValueSection> createState() => _KeyValueSectionState();
}

class _KeyValueSectionState extends State<KeyValueSection> {
  final _themeController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _themeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    final cubit = context.read<KeyValueDemoCubit>();
    return BlocBuilder<KeyValueDemoCubit, KeyValueDemoState>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.all(tokens.spacing.md),
          children: [
            VmCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Theme', style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: tokens.spacing.xs),
                  VmTextField(
                    controller: _themeController,
                    label: 'theme',
                    hint: state.entries[DemoPreferenceKey.theme] ?? 'unset',
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: tokens.spacing.sm),
                  VmButton(
                    label: 'Save',
                    onPressed: () => cubit.setValue(
                      DemoPreferenceKey.theme,
                      _themeController.text,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: tokens.spacing.md),
            VmCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Display name',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: tokens.spacing.xs),
                  VmTextField(
                    controller: _nameController,
                    label: 'display_name',
                    hint:
                        state.entries[DemoPreferenceKey.displayName] ?? 'unset',
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: tokens.spacing.sm),
                  VmButton(
                    label: 'Save',
                    onPressed: () => cubit.setValue(
                      DemoPreferenceKey.displayName,
                      _nameController.text,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: tokens.spacing.md),
            Text(
              'Stored values',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (state.entries.isEmpty)
              const VmEmptyView(message: 'No preferences saved yet.')
            else
              for (final entry in state.entries.entries)
                VmListItem(
                  title: Text(entry.key),
                  subtitle: Text(entry.value),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => cubit.removeValue(entry.key),
                  ),
                ),
            if (state.errorMessage != null) ...[
              SizedBox(height: tokens.spacing.sm),
              VmErrorView(message: state.errorMessage!),
            ],
          ],
        );
      },
    );
  }
}
