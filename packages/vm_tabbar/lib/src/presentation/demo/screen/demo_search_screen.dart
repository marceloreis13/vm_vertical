import 'package:flutter/material.dart';

/// Search branch root: a plain placeholder screen for the example's second
/// mock tab.
class DemoSearchScreen extends StatelessWidget {
  const DemoSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(child: Text('Search branch')),
    );
  }
}
