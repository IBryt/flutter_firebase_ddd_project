import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/notes_overview/widgets/critical_failure_display_widget.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/notes_overview/widgets/error_note_card_widget.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/notes_overview/widgets/note_card_widget.dart';

class NotesOverviewBodyWidget extends StatelessWidget {
  const NotesOverviewBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => Container(),
          loadingInProgress: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          loadSuccess: (state) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final note = state.notes[index];
                if (note.failureOption.isSome()) {
                  return ErrorNoteCardWidget(note: note);
                } else {
                  return NoteCardWidget(note: note);
                }
              },
              itemCount: state.notes.size,
            );
          },
          loadFailure: (state) {
            return CriticalFailureDisplay(
              failure: state.noteFailure,
            );
          },
        );
      },
    );
  }
}
