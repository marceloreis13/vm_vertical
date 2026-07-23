import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_demo_state.freezed.dart';

/// Display row for one demoed config key: its value at every layer of the
/// remote > cache > default precedence, plus the value `ConfigReader`
/// actually resolves.
@freezed
class ConfigDemoField with _$ConfigDemoField {
  const factory ConfigDemoField({
    required String key,
    required String label,
    required Object? defaultValue,
    required Object? cacheValue,
    required Object? remoteValue,
    required Object? resolvedValue,
  }) = _ConfigDemoField;
}

/// State of the `vm_config` visual example: one [ConfigDemoField] per
/// demoed key.
@freezed
class ConfigDemoState with _$ConfigDemoState {
  const factory ConfigDemoState({required List<ConfigDemoField> fields}) =
      _ConfigDemoState;

  factory ConfigDemoState.initial() => const ConfigDemoState(fields: []);
}
