// ignore_for_file: prefer_initializing_formals
// (field is private for encapsulation; the constructor's named parameter
// must stay public, so a plain initializing formal isn't available here.)

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/document_store.dart';
import 'demo_note.dart';

part 'document_demo_cubit.freezed.dart';

@freezed
class DocumentDemoState with _$DocumentDemoState {
  const factory DocumentDemoState({
    @Default([]) List<DemoNote> notes,
    @Default(false) bool softDeleteEnabled,
    String? errorMessage,
  }) = _DocumentDemoState;
}

/// Drives the `DocumentStore<DemoNote>` demo (Documents tab): add a note
/// with an optional TTL, delete it (soft or physical depending on
/// [DocumentDemoState.softDeleteEnabled]), and purge tombstones.
class DocumentDemoCubit extends Cubit<DocumentDemoState> {
  DocumentDemoCubit({
    required DocumentStore<DemoNote> store,
    required bool softDeleteEnabled,
  }) : _store = store,
       super(DocumentDemoState(softDeleteEnabled: softDeleteEnabled)) {
    unawaited(_refresh());
  }

  final DocumentStore<DemoNote> _store;

  Future<void> _refresh() async {
    final result = await _store.getAll();
    result.when(
      success: (notes) =>
          emit(state.copyWith(notes: notes, errorMessage: null)),
      failure: (failure) => emit(state.copyWith(errorMessage: failure.message)),
    );
  }

  Future<void> addNote(String text, {Duration? ttl}) async {
    final note = DemoNote(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
    );
    final result = await _store.put(note, ttl: ttl);
    result.when(
      success: (_) => null,
      failure: (failure) => emit(state.copyWith(errorMessage: failure.message)),
    );
    await _refresh();
  }

  Future<void> deleteNote(String id) async {
    await _store.delete(id);
    await _refresh();
  }

  Future<void> purgeTombstones() async {
    await _store.purge();
    await _refresh();
  }
}
