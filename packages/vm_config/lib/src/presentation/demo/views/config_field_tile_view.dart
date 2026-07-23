import 'package:flutter/material.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

/// Renders one config key's value at every precedence layer, plus its
/// resolved value, with a trailing action to mutate the remote value and a
/// button to clear it (demonstrating fallback to cache/default). Takes
/// plain parameters/callbacks only — no `Cubit`/`State`/repository.
class ConfigFieldTileView extends StatelessWidget {
  const ConfigFieldTileView({
    required this.label,
    required this.defaultDisplay,
    required this.cacheDisplay,
    required this.remoteDisplay,
    required this.resolvedDisplay,
    required this.action,
    required this.onClearRemote,
    super.key,
  });

  final String label;
  final String defaultDisplay;
  final String cacheDisplay;
  final String remoteDisplay;
  final String resolvedDisplay;
  final Widget action;
  final VoidCallback onClearRemote;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    return VmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              action,
              IconButton(
                tooltip: 'Clear remote value',
                onPressed: onClearRemote,
                icon: const Icon(Icons.backspace_outlined),
              ),
            ],
          ),
          SizedBox(height: tokens.spacing.sm),
          Wrap(
            spacing: tokens.spacing.sm,
            children: [
              Chip(label: Text('default: $defaultDisplay')),
              Chip(label: Text('cache: $cacheDisplay')),
              Chip(label: Text('remote: $remoteDisplay')),
            ],
          ),
          SizedBox(height: tokens.spacing.sm),
          Text(
            'resolved: $resolvedDisplay',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
