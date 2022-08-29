import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/auth/auth_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/notes/note_actor/note_actor_bloc.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/notes_overview/widgets/notes_overview_body_widget.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/notes_overview/widgets/uncompleted_switch.dart';
import 'package:flutter_firebase_ddd_project/presentation/routes/route_names.dart';
import 'package:go_router/go_router.dart';

class NotesOverviewWidget extends StatelessWidget {
  const NotesOverviewWidget({Key? key}) : super(key: key);

  void _handleListener(BuildContext context, NoteActorState state) {
    state.maybeMap(
      deleteFailure: (state) {
        (f) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  f.map(
                    unexpected: (_) =>
                        'Unexpected error occured while deleting, please contact support.',
                    insufficientPermission: (_) => 'Insufficient permissions ❌',
                    unableToUpdate: (_) => 'Impossible error',
                  ),
                ),
              ),
            );
      },
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return MultiBlocListener(
      listeners: [
        BlocListener<NoteActorBloc, NoteActorState>(
          listener: (context, state) => _handleListener(context, state),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => authBloc.add(const AuthEvent.signedOut()),
          ),
          actions: const [
            UncompletedSwitchWidget(),
          ],
        ),
        body: const NotesOverviewBodyWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.goNamed(noteFormRouteName, extra: null),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
