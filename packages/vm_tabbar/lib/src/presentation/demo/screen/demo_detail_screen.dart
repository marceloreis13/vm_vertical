import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A pushed sub-route (`/home/detail`) inside the Home branch, used to
/// demonstrate that a branch's navigation stack survives switching tabs.
class DemoDetailScreen extends StatelessWidget {
  const DemoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Center(
        child: FilledButton(
          onPressed: () => context.pop(),
          child: const Text('Back'),
        ),
      ),
    );
  }
}
