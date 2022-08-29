import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/notes/note_form/note_form_bloc.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/note_form/misc/build_context_x.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/note_form/misc/todo_item_presentation.dart';
import 'package:kt_dart/kt.dart';

class AddTodoTileWidget extends StatelessWidget {
  const AddTodoTileWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) =>
          previous.isEditing != current.isEditing,
      listener: (context, state) {
        context.formTodos = state.note.todos.value
            .fold(
                (f) => listOf<TodoItemPresentation>(),
                (todoItemList) =>
                    todoItemList.map((_) => TodoItemPresentation.fromDomain(_)))
            .toList();
      },
      buildWhen: (previous, current) =>
          previous.note.todos.isFull != current.note.todos.isFull,
      builder: (context, state) {
        return ListTile(
          enabled: !state.note.todos.isFull,
          title: const Text('Add a todo'),
          leading: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.add),
          ),
          onTap: () {
            context.formTodos = context.formTodos
                .plusElement(TodoItemPresentation.empty())
                .toList();
            context.read<NoteFormBloc>().add(
                  NoteFormEvent.todosChanged(context.formTodos),
                );
          },
        );
      },
    );
  }
}
