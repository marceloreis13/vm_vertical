import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/vm_tab_bar_state.dart';
import '../../../domain/vm_tab_bar_style.dart';
import '../../../domain/vm_tabbar_config.dart';
import '../vm_tab_bar_cubit.dart';
import '../views/vm_tab_bar.dart';

/// The `shellBuilder` target for a `vm_navigation` `VmShellRoute`: composes
/// `VmTabBar` with the shell's active branch body. Binds `VmTabBarCubit` —
/// this is the feature's Screen (see `vm-ui-composition`); `VmTabBar` itself
/// stays a plain View underneath it.
class VmTabShellScaffold extends StatefulWidget {
  const VmTabShellScaffold({
    required this.shell,
    this.config,
    this.getIt,
    super.key,
  });

  /// The live shell for the current navigation state, supplied by
  /// `VmShellRoute`'s `shellBuilder`. A fresh instance is delivered on every
  /// rebuild triggered by navigation; this widget reconciles the Cubit with
  /// it in [didUpdateWidget].
  final StatefulNavigationShell shell;

  /// Overrides the app-registered `VmTabbarConfig` — mainly for tests.
  /// Defaults to resolving `VmTabbarConfig` from [getIt].
  final VmTabbarConfig? config;

  /// Defaults to [GetIt.instance]; overridable for tests/embedding apps
  /// with a scoped container.
  final GetIt? getIt;

  @override
  State<VmTabShellScaffold> createState() => _VmTabShellScaffoldState();
}

class _VmTabShellScaffoldState extends State<VmTabShellScaffold> {
  late final VmTabbarConfig _config =
      widget.config ?? (widget.getIt ?? GetIt.instance)<VmTabbarConfig>();
  late final VmTabBarCubit _cubit = VmTabBarCubit(
    shell: widget.shell,
    tabs: _config.tabs,
  );

  @override
  void didUpdateWidget(covariant VmTabShellScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.shell, widget.shell)) {
      _cubit.syncWithShell(widget.shell);
    }
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _config.style ?? VmTabBarStyle.fromTheme(Theme.of(context));

    return BlocProvider<VmTabBarCubit>.value(
      value: _cubit,
      child: BlocBuilder<VmTabBarCubit, VmTabBarState>(
        bloc: _cubit,
        builder: (context, state) {
          return Scaffold(
            body: widget.shell,
            bottomNavigationBar: VmTabBar(
              tabs: _config.tabs,
              state: state,
              style: style,
              onTap: _cubit.select,
            ),
          );
        },
      ),
    );
  }
}
