import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/tokens/vm_theme_tokens_context.dart';
import '../../button/vm_button.dart';
import '../../segmented_control/vm_segmented_control.dart';
import '../gallery_cubit.dart';
import '../gallery_widgets.dart';

/// Actions tab: things you tap to act or choose. Reads `GalleryState.unit`.
class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    return GalleryCategory(
      demos: [
        GalleryDemo(
          label: 'Buttons',
          child: Wrap(
            spacing: tokens.spacing.sm,
            runSpacing: tokens.spacing.sm,
            children: [
              VmButton(label: 'Primary', onPressed: () {}),
              VmButton(
                label: 'Secondary',
                variant: VmButtonVariant.secondary,
                onPressed: () {},
              ),
              VmButton(
                label: 'Text',
                variant: VmButtonVariant.text,
                onPressed: () {},
              ),
              VmButton(
                label: 'With icon',
                icon: Icons.favorite_border,
                onPressed: () {},
              ),
            ],
          ),
        ),
        GalleryDemo(
          label: 'Segmented control',
          child: BlocBuilder<GalleryCubit, GalleryState>(
            builder: (context, state) => VmSegmentedControl<String>(
              segments: const [
                VmSegment(value: 'C', label: '°C'),
                VmSegment(value: 'F', label: '°F'),
              ],
              selected: state.unit,
              onChanged: context.read<GalleryCubit>().changeUnit,
            ),
          ),
        ),
      ],
    );
  }
}
