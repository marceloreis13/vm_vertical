import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../navigation/domain/vm_navigator_service.dart';
import '../demo_routes.dart';

/// Screen 2 (blocked outcome): reached only via the redirect that fires
/// when `DemoProtectedRoute`'s guard fails.
class DemoLoginScreen extends StatelessWidget {
  const DemoLoginScreen({this.getIt, super.key});

  final GetIt? getIt;

  @override
  Widget build(BuildContext context) {
    final navigator = (getIt ?? GetIt.instance)<VmNavigatorService>();
    final tokens = context.vmTokens;

    return Scaffold(
      appBar: const VmAppBar(title: 'Redirected'),
      body: Padding(
        padding: EdgeInsets.all(tokens.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const VmCard(
              child: Text(
                "You were redirected here because the protected route's "
                'guard failed. Flip the session toggle on Home and try '
                'again.',
              ),
            ),
            SizedBox(height: tokens.spacing.md),
            VmButton(
              label: 'Back to Home',
              onPressed: () => navigator.go(const DemoHomeRoute()),
            ),
          ],
        ),
      ),
    );
  }
}
