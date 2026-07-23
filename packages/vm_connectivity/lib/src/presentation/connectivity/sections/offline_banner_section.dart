import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/connectivity_state.dart';
import '../cubit/connectivity_cubit.dart';
import '../views/offline_banner_view.dart';

/// Watches the `ConnectivityCubit` (resolved from the nearest
/// `BlocProvider<ConnectivityCubit>`, typically registered by
/// `registerVmConnectivityModule`) and shows the [OfflineBannerView] only
/// while the state is `Offline`; hides it entirely while `Online`. Place it
/// anywhere in the app's widget tree (e.g. above a `Scaffold`'s body).
class OfflineBannerSection extends StatelessWidget {
  const OfflineBannerSection({
    this.message = 'You are offline. Some features may be unavailable.',
    super.key,
  });

  /// Forwarded to [OfflineBannerView]; consumer-overridable copy.
  final String message;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ConnectivityCubit>().state;
    return switch (state) {
      ConnectivityOnline() => const SizedBox.shrink(),
      ConnectivityOffline() => OfflineBannerView(message: message),
    };
  }
}
