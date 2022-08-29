import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_ddd_project/domain/auth/value_objects.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/todo_item.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';

part 'todo_item_presentation.freezed.dart';

class FormTodos extends ValueNotifier<KtList<TodoItemPresentation>> {
  FormTodos() : super(emptyList<TodoItemPresentation>());
}

@freezed
class TodoItemPresentation with _$TodoItemPresentation {
  const TodoItemPresentation._();

  factory TodoItemPresentation({
    required UniqueId id,
    required String name,
    required bool done,
  }) = _TodoItemPresentation;

  factory TodoItemPresentation.empty() => TodoItemPresentation(
        id: UniqueId(),
        name: '',
        done: false,
      );

  factory TodoItemPresentation.fromDomain(TodoItem todoItem) {
    return TodoItemPresentation(
      id: todoItem.id,
      name: todoItem.name.getOrCrash(),
      done: todoItem.done,
    );
  }

  TodoItem toDomain() {
    return TodoItem(
      id: id,
      name: TodoName(name),
      done: done,
    );
  }
}
