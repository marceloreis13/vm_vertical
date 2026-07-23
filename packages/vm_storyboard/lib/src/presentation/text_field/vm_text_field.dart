import 'package:flutter/material.dart';

import '../../domain/tokens/vm_theme_tokens_context.dart';

/// Standard text input, consuming only `VmThemeTokens`/`ThemeData`.
class VmTextField extends StatelessWidget {
  const VmTextField({
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    super.key,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final bool enabled;

  /// The on-screen keyboard shown for this field's content — e.g.
  /// `TextInputType.emailAddress` for an email field, `.phone` for a phone
  /// number. Callers must set this to match the field's actual purpose;
  /// `VmTextField` is generic and has no purpose of its own to infer it
  /// from.
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    return TextField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        contentPadding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.md,
          vertical: tokens.spacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radius.md),
        ),
      ),
    );
  }
}
