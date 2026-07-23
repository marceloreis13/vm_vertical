import 'package:flutter/material.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

/// Screen 2 of the `vm_analytics` example: reached from the home screen's
/// "Go to details" button, existing solely to demonstrate a route change
/// that `AnalyticsRouteObserver` picks up automatically — no explicit
/// `screenView` call is made from this screen.
class AnalyticsDemoDetailsScreen extends StatelessWidget {
  const AnalyticsDemoDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    return Scaffold(
      appBar: const VmAppBar(title: 'Details'),
      body: Padding(
        padding: EdgeInsets.all(tokens.spacing.lg),
        child: Center(
          child: VmCard(
            child: Text(
              'This screen view was tracked automatically by '
              'AnalyticsRouteObserver on navigation — go back to see it '
              'appear in the call list.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}
