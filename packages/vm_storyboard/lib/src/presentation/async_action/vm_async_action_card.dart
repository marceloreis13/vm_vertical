import 'package:flutter/material.dart';

import '../../domain/tokens/vm_theme_tokens_context.dart';
import '../button/vm_button.dart';
import '../card/vm_card.dart';
import '../states/vm_error_view.dart';
import '../states/vm_loading_view.dart';

/// Lifecycle of a user-triggered async action rendered by [VmAsyncActionCard].
enum VmAsyncStatus { idle, loading, success, error }

/// Generic "trigger an action, show its result" card: a title/description,
/// a button, and a body that reflects [status] (idle/loading/success/error)
/// via the standard `Vm*View` states. Domain-agnostic — callers supply the
/// success content and error message as plain widgets/strings.
class VmAsyncActionCard extends StatelessWidget {
  const VmAsyncActionCard({
    required this.title,
    required this.status,
    required this.buttonLabel,
    required this.onPressed,
    this.description,
    this.successContent,
    this.errorMessage,
    this.onRetry,
    super.key,
  });

  final String title;
  final String? description;
  final VmAsyncStatus status;
  final String buttonLabel;
  final VoidCallback? onPressed;

  /// Built only when [status] is [VmAsyncStatus.success].
  final Widget? successContent;

  /// Shown when [status] is [VmAsyncStatus.error].
  final String? errorMessage;

  /// Defaults to [onPressed] when omitted, so the error state's "Retry"
  /// button re-runs the same action.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    final textTheme = Theme.of(context).textTheme;
    return VmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: textTheme.titleMedium),
          if (description != null) ...[
            SizedBox(height: tokens.spacing.xs),
            Text(description!, style: textTheme.bodySmall),
          ],
          SizedBox(height: tokens.spacing.sm),
          VmButton(
            label: buttonLabel,
            onPressed: status == VmAsyncStatus.loading ? null : onPressed,
          ),
          SizedBox(height: tokens.spacing.sm),
          switch (status) {
            VmAsyncStatus.idle => const SizedBox.shrink(),
            VmAsyncStatus.loading => const VmLoadingView(),
            VmAsyncStatus.success => successContent ?? const SizedBox.shrink(),
            VmAsyncStatus.error => VmErrorView(
              message: errorMessage ?? 'Something went wrong.',
              onRetry: onRetry ?? onPressed,
            ),
          },
        ],
      ),
    );
  }
}
