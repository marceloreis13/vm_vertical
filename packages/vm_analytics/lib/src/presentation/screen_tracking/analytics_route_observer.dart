// ignore_for_file: prefer_initializing_formals
// (fields are private for encapsulation; the constructor's named parameters
// must stay public, so a plain initializing formal isn't available here.)

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../domain/analytics_tracker.dart';
import '../../domain/event_name_validator.dart';
import '../../domain/vm_analytics_config.dart';

/// A [NavigatorObserver] wired through the app's router configuration
/// (`GoRouter(observers: [...])`, from `vm_navigation`) that derives a
/// screen name from each route change and calls
/// `AnalyticsTracker.screenView` automatically — no per-screen call needed.
/// Gated behind `VmAnalyticsConfig.automaticScreenTracking`; a manual
/// `screenView(name)` remains available for flows this observer can't name.
/// See `screen-tracking`.
class AnalyticsRouteObserver extends NavigatorObserver {
  AnalyticsRouteObserver({
    required AnalyticsTracker tracker,
    required VmAnalyticsConfig config,
  }) : _tracker = tracker,
       _config = config;

  final AnalyticsTracker _tracker;
  final VmAnalyticsConfig _config;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _trackScreenView(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _trackScreenView(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) _trackScreenView(previousRoute);
  }

  void _trackScreenView(Route<dynamic> route) {
    if (!_config.automaticScreenTracking) return;
    final name = _screenNameOf(route);
    if (name == null) return;
    unawaited(_tracker.screenView(name));
  }

  /// Derives a screen name from [route]'s settings name, sanitized to the
  /// shared naming convention so an oddly-shaped route name never throws.
  /// Returns `null` (skip tracking) when the route carries no usable name,
  /// e.g. an anonymous dialog route.
  String? _screenNameOf(Route<dynamic> route) {
    final settingsName = route.settings.name;
    if (settingsName == null || settingsName.isEmpty) return null;
    return sanitizeAnalyticsName(settingsName);
  }
}
