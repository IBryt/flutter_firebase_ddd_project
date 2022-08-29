import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/notes/note_form/note_form_bloc.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/value_objects.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/note_form/misc/todo_item_presentation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/note_form/misc/build_context_x.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget({
    Key? key,
  }) : super(key: key);

  void _handleListener(BuildContext context, NoteFormState state) {
    if (state.note.todos.isFull) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Want longer lists? Activate premium 🤩'),
          action: SnackBarAction(
            label: 'BUY NOW',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteFormBloc = context.read<NoteFormBloc>();
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) =>
          previous.note.todos.isFull != current.note.todos.isFull &&
          previous.isEditing,
      listener: (context, state) => _handleListener(context, state),
      child: Consumer<FormTodos>(
        builder: (context, formTodos, child) {
          return ReorderableListView.builder(
            shrinkWrap: true,
            itemCount: formTodos.value.size,
            itemBuilder: (context, index) {
              return _TodoTileWidget(
                key: ValueKey(context.formTodos[index].id),
                index: index,
              );
            },
            onReorder: (int oldIndex, int newIndex) {
              if (newIndex > oldIndex) {
                newIndex = newIndex - 1;
              }
              final list = context.formTodos.toMutableList();
              final todo = list[oldIndex];
              list.removeAt(oldIndex);
              list.addAt(newIndex, todo);
              context.formTodos = list.toList();
              noteFormBloc.add(NoteFormEvent.todosChanged(context.formTodos));
            },
          );
        },
      ),
    );
  }
}

class _TodoTileWidget extends StatelessWidget {
  final int index;

  const _TodoTileWidget({
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todo =
        context.formTodos.getOrElse(index, (_) => TodoItemPresentation.empty());
    final noteFormBloc = context.read<NoteFormBloc>();

    return Slidable(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: _TodoTileTextFormFieldWidget(index: index),
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.15,
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              context.formTodos = context.formTodos.minusElement(todo).toList();
              noteFormBloc.add(NoteFormEvent.todosChanged(context.formTodos));
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
        ],
      ),
    );
  }
}

class _TodoTileTextFormFieldWidget extends HookWidget {
  final int index;

  const _TodoTileTextFormFieldWidget({
    Key? key,
    required this.index,
  }) : super(
          key: key,
        );

  String? _validator(NoteFormState state) {
    if (!state.showErrorMessages) {
      return null;
    }
    return state.note.todos.value.fold(
      (f) => null,
      (todoList) => todoList[index].name.value.fold(
            (f) => f.maybeMap(
              empty: (_) => 'Cannot be empty',
              exceedingLength: (_) => 'Too long',
              multiline: (_) => 'Has to be in a single line',
              orElse: () => null,
            ),
            (_) => null,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todo =
        context.formTodos.getOrElse(index, (_) => TodoItemPresentation.empty());
    final noteFormBloc = context.read<NoteFormBloc>();
    final textEditingController = useTextEditingController(text: todo.name);

    return ListTile(
      title: TextFormField(
        validator: (value) => _validator(noteFormBloc.state),
        controller: textEditingController,
        decoration: const InputDecoration(
          hintText: 'Todo',
          counterText: '',
          border: InputBorder.none,
        ),
        maxLength: TodoName.maxLength,
        onChanged: (value) {
          context.formTodos = context.formTodos
              .map(
                (listTodo) =>
                    listTodo == todo ? todo.copyWith(name: value) : listTodo,
              )
              .toList();
          noteFormBloc.add(NoteFormEvent.todosChanged(context.formTodos));
        },
      ),
      leading: Checkbox(
        value: todo.done,
        onChanged: (value) {
          if (value == null) {
            return;
          }
          context.formTodos = context.formTodos
              .map(
                (listTodo) =>
                    listTodo == todo ? todo.copyWith(done: value) : listTodo,
              )
              .toList();
          noteFormBloc.add(NoteFormEvent.todosChanged(context.formTodos));
        },
      ),
      trailing: const Icon(Icons.list),
    );
  }
}
