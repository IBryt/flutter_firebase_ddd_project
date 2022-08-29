import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/notes/note_form/note_form_bloc.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/value_objects.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BodyFieldWidget extends HookWidget {
  const BodyFieldWidget({
    Key? key,
  }) : super(key: key);

  String? _validator(NoteFormState state) {
    if (!state.showErrorMessages) {
      return null;
    }
    return state.note.body.value.fold(
      (f) => f.maybeMap(
        empty: (f) => 'Cannot be empty',
        exceedingLength: (f) => 'Exceeding length, max: ${f.max}',
        orElse: () => null,
      ),
      (r) => null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();
    final noteFormBloc = context.read<NoteFormBloc>();

    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) =>
          previous.isEditing != current.isEditing,
      listener: (context, state) =>
          textEditingController.text = state.note.body.getOrCrash(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          validator: (value) => _validator(noteFormBloc.state),
          controller: textEditingController,
          decoration: const InputDecoration(
            labelText: 'Note',
            counterText: '',
          ),
          maxLength: NoteBody.maxLength,
          maxLines: null,
          minLines: 5,
          onChanged: (value) =>
              noteFormBloc.add(NoteFormEvent.bodyChanged(value)),
        ),
      ),
    );
  }
}
