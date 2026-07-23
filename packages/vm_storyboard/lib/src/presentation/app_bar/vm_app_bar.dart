import 'package:flutter/material.dart';

/// Standard app bar. Styling (background, foreground, elevation) comes
/// entirely from `ThemeData.appBarTheme`, set by `buildVmTheme`.
class VmAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VmAppBar({
    required this.title,
    this.leading,
    this.actions,
    this.bottom,
    super.key,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  /// Optional bar rendered under the title, e.g. a `TabBar`.
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
