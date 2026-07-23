import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vm_logo.freezed.dart';

/// Slot contract for an app's logo. `vm_storyboard` ships no default asset;
/// every app registering the module MUST provide one.
@freezed
class VmLogo with _$VmLogo {
  const factory VmLogo({required WidgetBuilder builder}) = _VmLogo;

  factory VmLogo.mock() =>
      VmLogo(builder: (context) => const FlutterLogo(size: 32));
}
