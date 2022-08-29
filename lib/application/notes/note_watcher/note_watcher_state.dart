part of 'note_watcher_bloc.dart';

@freezed
class NoteWatcherState with _$NoteWatcherState {
  const factory NoteWatcherState.initial() = _Initial;

  const factory NoteWatcherState.loadingInProgress() = _LoadingInProgress;

  const factory NoteWatcherState.loadSuccess(KtList<Note> notes) = _LoadSuccess;

  const factory NoteWatcherState.loadFailure(NoteFailure noteFailure) =
      _LoadFailure;
}
