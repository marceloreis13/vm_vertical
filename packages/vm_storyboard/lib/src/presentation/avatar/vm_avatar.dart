import 'package:flutter/material.dart';

/// Circular image with a loading placeholder and a fallback icon on error,
/// consuming only `ThemeData`.
class VmAvatar extends StatelessWidget {
  const VmAvatar({
    required this.image,
    this.size = 40,
    this.fallbackIcon = Icons.person,
    super.key,
  });

  final ImageProvider image;
  final double size;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Image(
          image: image,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return ColoredBox(
              color: colorScheme.surfaceContainerHighest,
              child: Center(
                child: SizedBox(
                  width: size * 0.4,
                  height: size * 0.4,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => ColoredBox(
            color: colorScheme.surfaceContainerHighest,
            child: Icon(
              fallbackIcon,
              size: size * 0.6,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
