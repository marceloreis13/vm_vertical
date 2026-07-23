import 'package:flutter/material.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../domain/notification_kind.dart';
import '../../../domain/notification_payload.dart';

/// Renders one received/simulated [NotificationPayload]: title, body and a
/// chip for its delivery kind. Takes plain parameters only — no
/// `Cubit`/`State`/repository.
class NotificationLogTileView extends StatelessWidget {
  const NotificationLogTileView({required this.payload, super.key});

  final NotificationPayload payload;

  @override
  Widget build(BuildContext context) {
    return VmListItem(
      title: Text(payload.title),
      subtitle: Text(payload.body),
      trailing: Chip(
        label: Text(payload.kind == NotificationKind.push ? 'push' : 'local'),
      ),
    );
  }
}
