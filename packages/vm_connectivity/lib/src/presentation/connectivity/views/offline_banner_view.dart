import 'package:flutter/material.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

/// Plain rendering of the offline notice, composed from `vm_storyboard`'s
/// `VmBanner`. Takes no `Cubit`/`State` — only constructor parameters — so it
/// can be pumped standalone and is the natural golden-test surface. See
/// `OfflineBannerSection` for the state-aware wiring.
class OfflineBannerView extends StatelessWidget {
  const OfflineBannerView({
    this.message = 'You are offline. Some features may be unavailable.',
    super.key,
  });

  /// Consumer-overridable copy — no app-specific text is hard-coded in the
  /// module beyond this sensible default.
  final String message;

  @override
  Widget build(BuildContext context) {
    return VmBanner(message: message, icon: Icons.wifi_off);
  }
}
