import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_change.freezed.dart';

/// A change event emitted on `ConfigReader.changes`: the set of keys whose
/// resolved value changed after a resolution recompute (e.g. following a
/// successful `refresh()`). Only keys whose resolved value actually changed
/// are included — never the full snapshot.
@freezed
class ConfigChange with _$ConfigChange {
  const factory ConfigChange({required Set<String> keys}) = _ConfigChange;
}
