import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/vm_badge.dart';

/// A tiny, self-contained live badge source for the visual example: an
/// incrementing counter driving the Profile tab's badge, proving the
/// reactive badge path end to end (`tab-navigation`, `tabbar-example`) with
/// no vendor SDK.
class DemoBadgeSource {
  DemoBadgeSource({this.interval = const Duration(seconds: 2)});

  final Duration interval;
  final ValueNotifier<VmBadge?> notifier = ValueNotifier<VmBadge?>(
    const VmBadge.count(0),
  );
  Timer? _timer;

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) {
      final current = notifier.value;
      final next = switch (current) {
        VmBadgeCount(:final value) => value + 1,
        _ => 1,
      };
      notifier.value = VmBadge.count(next);
    });
  }

  void dispose() {
    _timer?.cancel();
    notifier.dispose();
  }
}
