import 'package:flutter/material.dart';

import '../../domain/tokens/vm_theme_tokens_context.dart';

/// Shared layout helpers for gallery Sections. Internal to the gallery, not
/// part of the package's public API.
class GalleryCategory extends StatelessWidget {
  const GalleryCategory({required this.demos, super.key});

  final List<Widget> demos;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    return ListView(
      padding: EdgeInsets.all(tokens.spacing.lg),
      children: [
        for (final demo in demos) ...[
          demo,
          SizedBox(height: tokens.spacing.xl),
        ],
      ],
    );
  }
}

class GalleryDemo extends StatelessWidget {
  const GalleryDemo({required this.label, required this.child, super.key});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: tokens.spacing.md),
        child,
      ],
    );
  }
}
