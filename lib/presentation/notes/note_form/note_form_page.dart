import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/notes/note_form/note_form_bloc.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/note.dart';
import 'package:flutter_firebase_ddd_project/injection.dart' as injection;
import 'package:flutter_firebase_ddd_project/presentation/notes/note_form/misc/todo_item_presentation.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/note_form/widgets/add_todo_tile_widget.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/note_form/widgets/body_field_widget.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/note_form/widgets/color_field_widget.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/note_form/widgets/todo_list_widget.dart';
import 'package:flutter_firebase_ddd_project/presentation/routes/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NoteFormPage extends StatelessWidget {
  final Note? editedNote;

  const NoteFormPage({
    Key? key,
    required this.editedNote,
  }) : super(key: key);

  void _showError(BuildContext context, NoteFormState state) {
    state.saveFailureOrSuccessOption.fold(
      () {},
      (either) {
        either.fold(
          (f) {
            if (!state.showErrorMessages) {
              return none();
            }
            return ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  f.map(
                    insufficientPermission: (_) => 'Insufficient permissions ❌',
                    unableToUpdate: (_) =>
                        "Couldn't update the note. Was it deleted from another device?",
                    unexpected: (_) =>
                        'Unexpected error occured, please contact support.',
                  ),
                ),
              ),
            );
          },
          (_) {
            context.goNamed(homeRouteName);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injection.get<NoteFormBloc>()
        ..add(NoteFormEvent.initialize(optionOf(editedNote))),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (previous, current) =>
            previous.saveFailureOrSuccessOption !=
            current.saveFailureOrSuccessOption,
        listener: (context, state) => _showError(context, state),
        buildWhen: (previous, current) => previous.isSaving != current.isSaving,
        builder: (context, state) {
          return Stack(
            children: [
              const _NoteFormPageScaffoldWidget(),
              _SavingInProgressOverlayWidget(isSaving: state.isSaving)
            ],
          );
        },
      ),
    );
  }
}

class _SavingInProgressOverlayWidget extends StatelessWidget {
  final bool isSaving;

  const _SavingInProgressOverlayWidget({
    Key? key,
    required this.isSaving,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isSaving,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: isSaving ? Colors.black.withOpacity(0.8) : Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        child: Visibility(
          visible: isSaving,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text(
                'Saving',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteFormPageScaffoldWidget extends StatelessWidget {
  const _NoteFormPageScaffoldWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noteFormBloc = context.read<NoteFormBloc>();
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (previous, current) =>
              previous.isEditing != current.isEditing,
          builder: (context, state) {
            return Text(state.isEditing ? 'Edit a note' : 'Create a note');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => noteFormBloc.add(const NoteFormEvent.saved()),
          )
        ],
      ),
      body: BlocBuilder<NoteFormBloc, NoteFormState>(
        buildWhen: (previous, current) =>
            previous.showErrorMessages != current.showErrorMessages,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => FormTodos(),
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    BodyFieldWidget(),
                    ColorFieldWidget(),
                    TodoListWidget(),
                    AddTodoTileWidget(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
