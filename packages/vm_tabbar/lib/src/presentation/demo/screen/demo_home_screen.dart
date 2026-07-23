import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home branch root: a scrolled list plus a button that pushes `/home/detail`
/// as a sub-route, so the example can demonstrate state preservation —
/// scroll away, switch tabs, come back, and the list's scroll position and
/// any pushed sub-route are exactly as left.
class DemoHomeScreen extends StatelessWidget {
  const DemoHomeScreen({super.key});

  static const int itemCount = 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView.builder(
        itemCount: itemCount + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: () => context.push('/home/detail'),
                child: const Text('Push a sub-route'),
              ),
            );
          }
          return ListTile(title: Text('Home item ${index - 1}'));
        },
      ),
    );
  }
}
