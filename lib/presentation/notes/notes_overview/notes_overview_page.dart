import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/notes/note_actor/note_actor_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:flutter_firebase_ddd_project/injection.dart' as injection;
import 'package:flutter_firebase_ddd_project/presentation/notes/notes_overview/widgets/note_overview_widget.dart';

class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteWatcherBloc>(
          create: (context) => injection.get<NoteWatcherBloc>()
            ..add(const NoteWatcherEvent.watchAllStarted()),
        ),
        BlocProvider<NoteActorBloc>(
          create: (context) => injection.get<NoteActorBloc>(),
        ),
      ],
      child: const NotesOverviewWidget(),
    );
  }
}
