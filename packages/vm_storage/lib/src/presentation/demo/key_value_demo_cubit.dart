// ignore_for_file: prefer_initializing_formals
// (field is private for encapsulation; the constructor's named parameter
// must stay public, so a plain initializing formal isn't available here.)

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/key_value_store.dart';

part 'key_value_demo_cubit.freezed.dart';

/// Preference keys demoed by [KeyValueDemoCubit].
class DemoPreferenceKey {
  static const theme = 'theme';
  static const displayName = 'display_name';

  static const all = [theme, displayName];
}

@freezed
class KeyValueDemoState with _$KeyValueDemoState {
  const factory KeyValueDemoState({
    @Default({}) Map<String, String> entries,
    String? errorMessage,
  }) = _KeyValueDemoState;
}

/// Drives the `KeyValueStore` CRUD demo (Preferences tab).
class KeyValueDemoCubit extends Cubit<KeyValueDemoState> {
  KeyValueDemoCubit({required KeyValueStore store})
    : _store = store,
      super(const KeyValueDemoState()) {
    unawaited(_refresh());
  }

  final KeyValueStore _store;

  Future<void> _refresh() async {
    final entries = <String, String>{};
    for (final key in DemoPreferenceKey.all) {
      final result = await _store.get<String>(key);
      result.when(success: (value) => entries[key] = value, failure: (_) {});
    }
    emit(state.copyWith(entries: entries));
  }

  Future<void> setValue(String key, String value) async {
    final result = await _store.set(key, value);
    result.when(
      success: (_) => emit(state.copyWith(errorMessage: null)),
      failure: (failure) => emit(state.copyWith(errorMessage: failure.message)),
    );
    await _refresh();
  }

  Future<void> removeValue(String key) async {
    await _store.remove(key);
    await _refresh();
  }
}
