import 'package:flutter/material.dart';

import '../../domain/tokens/vm_theme_tokens_context.dart';

/// Search input with a leading search icon and a clear action, consuming
/// only `VmThemeTokens`/`ThemeData`. Its purpose is fixed, so the keyboard
/// action is always `TextInputAction.search` — no `keyboardType` parameter
/// to set, unlike `VmTextField`.
class VmSearchField extends StatelessWidget {
  const VmSearchField({
    required this.controller,
    this.hint = 'Search',
    this.onChanged,
    this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  onClear?.call();
                  onChanged?.call('');
                },
              ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.md,
          vertical: tokens.spacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radius.xl),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
