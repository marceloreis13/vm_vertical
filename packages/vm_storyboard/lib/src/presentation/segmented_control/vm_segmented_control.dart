import 'package:flutter/material.dart';

import '../../domain/tokens/vm_theme_tokens_context.dart';

/// A single option in a [VmSegmentedControl].
class VmSegment<T> {
  const VmSegment({required this.value, required this.label});

  final T value;
  final String label;
}

/// Standard segmented control (e.g. unit toggles), consuming only
/// `VmThemeTokens`/`ThemeData`.
class VmSegmentedControl<T extends Object> extends StatelessWidget {
  const VmSegmentedControl({
    required this.segments,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<VmSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    return SegmentedButton<T>(
      segments: [
        for (final segment in segments)
          ButtonSegment(value: segment.value, label: Text(segment.label)),
      ],
      selected: {selected},
      showSelectedIcon: false,
      onSelectionChanged: (values) => onChanged(values.first),
      style: SegmentedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radius.md),
        ),
      ),
    );
  }
}
