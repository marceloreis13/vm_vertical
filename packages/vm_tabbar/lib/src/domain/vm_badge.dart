import 'package:freezed_annotation/freezed_annotation.dart';

part 'vm_badge.freezed.dart';

/// A tab's badge value: either a numeric [VmBadgeCount] or an unlabeled
/// [VmBadgeDot]. `null` (no [VmBadge] at all) means "no badge".
@freezed
sealed class VmBadge with _$VmBadge {
  /// A count badge, e.g. an unread-messages counter.
  const factory VmBadge.count(int value) = VmBadgeCount;

  /// A dot badge with no label, e.g. "there is something new".
  const factory VmBadge.dot() = VmBadgeDot;
}
