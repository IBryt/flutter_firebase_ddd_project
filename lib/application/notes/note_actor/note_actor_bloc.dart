import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/i_note_repository.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/note.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_actor_event.dart';

part 'note_actor_state.dart';

part 'note_actor_bloc.freezed.dart';

class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INoteRepository _noteRepository;

  NoteActorBloc(this._noteRepository) : super(const NoteActorState.initial()) {
    on<NoteActorEvent>(
      (event, emit) async => await _onNoteActorEvent(event, emit),
      transformer: sequential(),
    );
  }

  Future<void> _onNoteActorEvent(
    NoteActorEvent event,
    Emitter<NoteActorState> emit,
  ) async {
    emit(const NoteActorState.actionInProgress());
    final possibleFailure = await _noteRepository.delete(event.note);
    final newState = possibleFailure.fold(
      (f) => NoteActorState.deleteFailure(f),
      (r) => const NoteActorState.deleteSuccess(),
    );
    emit(newState);
  }
}
