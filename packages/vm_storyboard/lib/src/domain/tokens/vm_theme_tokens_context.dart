import 'package:flutter/material.dart';

import 'vm_theme_tokens.dart';

/// Reads `VmThemeTokens` from the active `ThemeData`. Every `Vm*` component
/// uses this instead of a hard-coded literal.
extension VmThemeTokensContext on BuildContext {
  VmThemeTokens get vmTokens => Theme.of(this).extension<VmThemeTokens>()!;
}
