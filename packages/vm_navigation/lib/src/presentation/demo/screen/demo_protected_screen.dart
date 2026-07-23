import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../navigation/domain/vm_navigator_service.dart';
import '../demo_routes.dart';

/// Screen 2 (allowed outcome): rendered only when `DemoProtectedRoute`'s
/// guard passes.
class DemoProtectedScreen extends StatelessWidget {
  const DemoProtectedScreen({this.getIt, super.key});

  final GetIt? getIt;

  @override
  Widget build(BuildContext context) {
    final navigator = (getIt ?? GetIt.instance)<VmNavigatorService>();
    final tokens = context.vmTokens;

    return Scaffold(
      appBar: const VmAppBar(title: 'Protected route'),
      body: Padding(
        padding: EdgeInsets.all(tokens.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const VmCard(child: Text('Guard passed — you are logged in.')),
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
