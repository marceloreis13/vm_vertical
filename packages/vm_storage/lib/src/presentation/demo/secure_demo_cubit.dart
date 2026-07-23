// ignore_for_file: prefer_initializing_formals
// (field is private for encapsulation; the constructor's named parameter
// must stay public, so a plain initializing formal isn't available here.)

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/secure_store.dart';

part 'secure_demo_cubit.freezed.dart';

const _tokenKey = 'access_token';

@freezed
class SecureDemoState with _$SecureDemoState {
  const factory SecureDemoState({String? token, String? errorMessage}) =
      _SecureDemoState;
}

/// Drives the `SecureStore` demo (Secure tab): store and read a sensitive
/// token.
class SecureDemoCubit extends Cubit<SecureDemoState> {
  SecureDemoCubit({required SecureStore store})
    : _store = store,
      super(const SecureDemoState()) {
    unawaited(_refresh());
  }

  final SecureStore _store;

  Future<void> _refresh() async {
    final result = await _store.get(_tokenKey);
    result.when(
      success: (value) =>
          emit(state.copyWith(token: value, errorMessage: null)),
      failure: (_) => emit(state.copyWith(token: null)),
    );
  }

  Future<void> saveToken(String value) async {
    final result = await _store.set(_tokenKey, value);
    result.when(
      success: (_) => null,
      failure: (failure) => emit(state.copyWith(errorMessage: failure.message)),
    );
    await _refresh();
  }

  Future<void> clearToken() async {
    await _store.remove(_tokenKey);
    await _refresh();
  }
}
