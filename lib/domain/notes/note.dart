import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_project/domain/auth/value_objects.dart';
import 'package:flutter_firebase_ddd_project/domain/core/failures.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/todo_item.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';

part 'note.freezed.dart';

@freezed
class Note with _$Note {
  const Note._();

  const factory Note({
    required UniqueId id,
    required NoteBody body,
    required NoteColor color,
    required List3<TodoItem> todos,
  }) = _Note;

  factory Note.empty() => Note(
        id: UniqueId(),
        color: NoteColor(NoteColor.predefinedColors.first),
        body: NoteBody(''),
        todos: List3(emptyList()),
      );

  Option<ValueFailure<dynamic>> get failureOption {
    return body.failureOrUnit
        .andThen(todos.failureOrUnit)
        .andThen(
          todos
              .getOrCrash()
              .map((todoItem) => todoItem.failureOption)
              .filter((o) => o.isSome())
              .getOrElse(0, (_) => none())
              .fold(() => right(unit), (f) => left(f)),
        )
        .fold((f) => some(f), (_) => none());
  }
}
