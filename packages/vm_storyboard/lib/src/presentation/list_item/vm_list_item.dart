import 'package:flutter/material.dart';

import '../../domain/tokens/vm_theme_tokens_context.dart';

/// Standard list row: leading/title/subtitle/trailing, consuming only
/// `VmThemeTokens`/`ThemeData`.
class VmListItem extends StatelessWidget {
  const VmListItem({
    required this.title,
    this.leading,
    this.subtitle,
    this.trailing,
    this.onTap,
    super.key,
  });

  final Widget title;
  final Widget? leading;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(tokens.radius.md),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.md,
          vertical: tokens.spacing.sm,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              SizedBox(width: tokens.spacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle(style: textTheme.titleMedium!, child: title),
                  if (subtitle != null)
                    DefaultTextStyle(
                      style: textTheme.bodyMedium!,
                      child: subtitle!,
                    ),
                ],
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: tokens.spacing.md),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
