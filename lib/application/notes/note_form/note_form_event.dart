part of 'note_form_bloc.dart';

@freezed
class NoteFormEvent with _$NoteFormEvent {
  const factory NoteFormEvent.initialize(Option<Note> initialNoteOption) =
      Initialize;

  const factory NoteFormEvent.bodyChanged(String bodyStr) = _BodyChanged;

  const factory NoteFormEvent.colorChanged(Color color) = _ColorChanged;

  const factory NoteFormEvent.todosChanged(KtList<TodoItemPresentation> todos) =
      _TodosChanged;

  const factory NoteFormEvent.saved() = _Saved;
}
