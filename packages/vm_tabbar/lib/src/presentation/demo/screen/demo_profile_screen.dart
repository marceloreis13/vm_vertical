import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/vm_badge.dart';
import '../demo_badge_source.dart';

/// Profile branch root: displays the live-incrementing badge value driven
/// by [DemoBadgeSource], proving the reactive badge path updates on screen
/// without reconfiguring the tab list.
class DemoProfileScreen extends StatelessWidget {
  const DemoProfileScreen({this.getIt, super.key});

  /// Defaults to [GetIt.instance]; overridable for tests/embedding apps
  /// with a scoped container.
  final GetIt? getIt;

  @override
  Widget build(BuildContext context) {
    final badgeSource = (getIt ?? GetIt.instance)<DemoBadgeSource>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ValueListenableBuilder<VmBadge?>(
          valueListenable: badgeSource.notifier,
          builder: (context, badge, _) {
            final count = switch (badge) {
              VmBadgeCount(:final value) => value,
              _ => 0,
            };
            return Text('Unread notifications: $count');
          },
        ),
      ),
    );
  }
}
