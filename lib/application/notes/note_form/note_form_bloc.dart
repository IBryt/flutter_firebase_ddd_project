import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/i_note_repository.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/note.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/note_failure.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/value_objects.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/note_form/misc/todo_item_presentation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

part 'note_form_event.dart';

part 'note_form_state.dart';

part 'note_form_bloc.freezed.dart';

class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  final INoteRepository _noteRepository;

  NoteFormBloc(this._noteRepository) : super(NoteFormState.initial()) {
    on<NoteFormEvent>(
      (event, emit) async => await _onNoteFormEvent(event, emit),
      transformer: sequential(),
    );
  }

  Future<void> _onNoteFormEvent(
    NoteFormEvent event,
    Emitter<NoteFormState> emit,
  ) async {
    await event.map(
      initialize: (_) async => await _onInitialize(event, emit),
      bodyChanged: (_) async => await _onBodyChanged(event, emit),
      colorChanged: (_) async => await _onColorChanged(event, emit),
      todosChanged: (_) async => await _onTodosChanged(event, emit),
      saved: (_) async => await _onSaved(event, emit),
    );
  }

  Future<void> _onInitialize(event, emit) async {
    final newState = event.initialNoteOption.fold(
      () => state,
      (initialNote) => state.copyWith(
        note: initialNote,
        isEditing: true,
      ),
    );
    emit(newState);
  }

  Future<void> _onBodyChanged(event, emit) async {
    final newState = state.copyWith(
      note: state.note.copyWith(body: NoteBody(event.bodyStr)),
      saveFailureOrSuccessOption: none(),
    );
    emit(newState);
  }

  Future<void> _onColorChanged(event, emit) async {
    final newState = state.copyWith(
      note: state.note.copyWith(color: NoteColor(event.color)),
      saveFailureOrSuccessOption: none(),
    );
    emit(newState);
  }

  Future<void> _onTodosChanged(event, emit) async {
    final newState = state.copyWith(
      note: state.note.copyWith(
        todos: List3(
          (event.todos as KtList).map(
            (presentation) => presentation.toDomain(),
          ),
        ),
      ),
      saveFailureOrSuccessOption: none(),
    );
    emit(newState);
  }

  Future<void> _onSaved(event, emit) async {
    Either<NoteFailure, Unit>? failureOrSuccess;
    NoteFormState newState = state.copyWith(
      isSaving: true,
      saveFailureOrSuccessOption: none(),
    );
    emit(newState);
    if (state.note.failureOption.isNone()) {
      failureOrSuccess = state.isEditing
          ? await _noteRepository.update(state.note)
          : await _noteRepository.create(state.note);
    }
    newState = state.copyWith(
      isSaving: false,
      showErrorMessages: true,
      saveFailureOrSuccessOption: optionOf(failureOrSuccess),
    );
    emit(newState);
  }
}
