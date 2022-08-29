import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/note_form/misc/todo_item_presentation.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

extension FormTodosX on BuildContext {
  KtList<TodoItemPresentation> get formTodos =>
      Provider.of<FormTodos>(this, listen: false).value;
  set formTodos(KtList<TodoItemPresentation> value) =>
      Provider.of<FormTodos>(this, listen: false).value = value;
}
