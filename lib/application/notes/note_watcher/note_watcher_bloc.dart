import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/i_note_repository.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/note.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

part 'note_watcher_event.dart';

part 'note_watcher_state.dart';

part 'note_watcher_bloc.freezed.dart';

class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INoteRepository _noteRepository;

  StreamSubscription<Either<NoteFailure, KtList<Note>>>? _noteSubscription;

  NoteWatcherBloc(this._noteRepository)
      : super(const NoteWatcherState.initial()) {
    on<NoteWatcherEvent>(
      (event, emit) async => await _onNoteWatcherEvent(event, emit),
      transformer: sequential(),
    );
  }

  Future<void> _onNoteWatcherEvent(
    NoteWatcherEvent event,
    Emitter<NoteWatcherState> emit,
  ) async {
    await event.map(
      watchAllStarted: (_) async => await _onWatchAllStarted(event, emit),
      watchUncompletedStarted: (_) async =>
          await _onWatchUncompletedStarted(event, emit),
      notesReceived: (_) async => await _onNotesReceived(event, emit),
    );
  }

  Future<void> _onWatchAllStarted(event, emit) async {
    emit(const NoteWatcherState.loadingInProgress());
    await _noteSubscription?.cancel();
    _noteSubscription = _noteRepository.watchAll().listen((failureOrNotes) =>
        add(NoteWatcherEvent.notesReceived(failureOrNotes)));
  }

  Future<void> _onWatchUncompletedStarted(event, emit) async {
    emit(const NoteWatcherState.loadingInProgress());
    await _noteSubscription?.cancel();
    _noteSubscription = _noteRepository.watchUncompleted().listen(
        (failureOrNotes) =>
            add(NoteWatcherEvent.notesReceived(failureOrNotes)));
  }

  Future<void> _onNotesReceived(event, emit) async {
    final newState = event.failureOrNotes.fold(
      (f) => NoteWatcherState.loadFailure(f),
      (notes) => NoteWatcherState.loadSuccess(notes),
    );
    emit(newState);
  }

  @override
  Future<void> close() {
    _noteSubscription?.cancel();
    return super.close();
  }
}
