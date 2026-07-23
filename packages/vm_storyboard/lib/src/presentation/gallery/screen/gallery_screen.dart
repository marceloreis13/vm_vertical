import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_bar/vm_app_bar.dart';
import '../gallery_cubit.dart';
import '../sections/actions_section.dart';
import '../sections/feedback_section.dart';
import '../sections/inputs_section.dart';
import '../sections/surfaces_section.dart';

/// Entry point of the `vm_storyboard` gallery/catalog: binds `GalleryCubit`
/// and composes the tab Sections. Also the golden-test baseline for
/// `storyboard-example` (see `vm-testing`).
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({
    required this.themeMode,
    required this.onToggleTheme,
    this.extraActions = const [],
    super.key,
  });

  /// The app shell's current theme mode, so the toggle icon can reflect it.
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  /// Extra `AppBar` actions the consuming app wants next to the theme
  /// toggle — e.g. a palette switcher in `example/`. `GalleryScreen` stays
  /// agnostic of what they are.
  final List<Widget> extraActions;

  static const _tabs = ['Actions', 'Inputs', 'Surfaces', 'Feedback'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GalleryCubit(),
      child: DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: VmAppBar(
            title: 'vm_storyboard gallery',
            actions: [
              ...extraActions,
              IconButton(
                icon: Icon(
                  themeMode == ThemeMode.light
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                ),
                onPressed: onToggleTheme,
              ),
            ],
            bottom: TabBar(tabs: [for (final tab in _tabs) Tab(text: tab)]),
          ),
          body: const TabBarView(
            children: [
              ActionsSection(),
              InputsSection(),
              SurfacesSection(),
              FeedbackSection(),
            ],
          ),
        ),
      ),
    );
  }
}
