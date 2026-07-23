import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gallery_cubit.freezed.dart';

/// Interaction state for the `vm_storyboard` gallery. Pure UI demo state —
/// no domain/data layer, since the gallery has no business flow of its own.
@freezed
class GalleryState with _$GalleryState {
  const factory GalleryState({
    @Default({'Featured'}) Set<String> selectedChips,
    @Default('C') String unit,
    @Default(true) bool showBanner,
  }) = _GalleryState;
}

/// Orchestrates the gallery's interactive demos (Inputs/Feedback tabs).
/// Sections read this state and dispatch back to it — see `vm-ui-composition`.
class GalleryCubit extends Cubit<GalleryState> {
  GalleryCubit() : super(const GalleryState());

  void setChipSelected(String label, bool selected) {
    final chips = Set<String>.from(state.selectedChips);
    if (selected) {
      chips.add(label);
    } else {
      chips.remove(label);
    }
    emit(state.copyWith(selectedChips: chips));
  }

  void changeUnit(String unit) => emit(state.copyWith(unit: unit));

  void dismissBanner() => emit(state.copyWith(showBanner: false));
}
