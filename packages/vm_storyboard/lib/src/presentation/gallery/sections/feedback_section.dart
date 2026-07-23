import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../badge/vm_badge.dart';
import '../../banner/vm_banner.dart';
import '../../button/vm_button.dart';
import '../../dialog/vm_dialog.dart';
import '../../snackbar/vm_snackbar.dart';
import '../../states/vm_empty_view.dart';
import '../../states/vm_error_view.dart';
import '../../states/vm_loading_view.dart';
import '../gallery_cubit.dart';
import '../gallery_widgets.dart';

/// Feedback tab: how the system communicates back to the user. Reads
/// `GalleryState.showBanner`.
class FeedbackSection extends StatelessWidget {
  const FeedbackSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GalleryCategory(
      demos: [
        BlocBuilder<GalleryCubit, GalleryState>(
          builder: (context, state) => state.showBanner
              ? GalleryDemo(
                  label: 'Banner',
                  child: VmBanner(
                    message: 'You are offline. Some content may be outdated.',
                    icon: Icons.wifi_off,
                    onDismiss: () =>
                        context.read<GalleryCubit>().dismissBanner(),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        GalleryDemo(
          label: 'Badge',
          child: VmBadge(
            count: 3,
            child: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        GalleryDemo(
          label: 'Snackbar',
          child: VmButton(
            label: 'Show snackbar',
            onPressed: () => showVmSnackbar(context, 'Saved successfully'),
          ),
        ),
        GalleryDemo(
          label: 'Dialog',
          child: VmButton(
            label: 'Show dialog',
            onPressed: () => showVmDialog<void>(
              context,
              title: 'Delete article?',
              message: 'This action cannot be undone.',
            ),
          ),
        ),
        GalleryDemo(
          label: 'Loading state',
          child: const SizedBox(
            height: 120,
            child: VmLoadingView(message: 'Loading...'),
          ),
        ),
        GalleryDemo(
          label: 'Empty state',
          child: SizedBox(
            height: 200,
            child: VmEmptyView(
              message: 'No results yet',
              actionLabel: 'Retry',
              onAction: () {},
            ),
          ),
        ),
        GalleryDemo(
          label: 'Error state',
          child: SizedBox(
            height: 200,
            child: VmErrorView(message: 'Something went wrong', onRetry: () {}),
          ),
        ),
      ],
    );
  }
}
