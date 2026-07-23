import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/tokens/vm_theme_tokens_context.dart';
import '../../chip/vm_chip.dart';
import '../../search_field/vm_search_field.dart';
import '../../text_field/vm_text_field.dart';
import '../gallery_cubit.dart';
import '../gallery_widgets.dart';

/// Inputs tab: data entry and filtering. Reads `GalleryState.selectedChips`.
/// Owns a local `TextEditingController` — plain widget-lifecycle plumbing,
/// not feature state, so it does not go through the Cubit.
class InputsSection extends StatefulWidget {
  const InputsSection({super.key});

  @override
  State<InputsSection> createState() => _InputsSectionState();
}

class _InputsSectionState extends State<InputsSection> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GalleryCategory(
      demos: [
        const GalleryDemo(
          label: 'Text field',
          child: VmTextField(
            label: 'Email',
            hint: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
          ),
        ),
        GalleryDemo(
          label: 'Search field',
          child: VmSearchField(
            controller: _searchController,
            hint: 'Search articles',
            onChanged: (_) => setState(() {}),
          ),
        ),
        GalleryDemo(
          label: 'Chips',
          child: BlocBuilder<GalleryCubit, GalleryState>(
            builder: (context, state) => Wrap(
              spacing: context.vmTokens.spacing.sm,
              children: [
                for (final label in ['Featured', 'Tech', 'World', 'Sports'])
                  VmChip(
                    label: label,
                    selected: state.selectedChips.contains(label),
                    onSelected: (selected) => context
                        .read<GalleryCubit>()
                        .setChipSelected(label, selected),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
