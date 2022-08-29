import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UncompletedSwitchWidget extends HookWidget {
  const UncompletedSwitchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toggleState = useState(false);
    final noteWatcherBloc = context.read<NoteWatcherBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkResponse(
        onTap: () {
          toggleState.value = !toggleState.value;
          noteWatcherBloc.add(
            toggleState.value
                ? const NoteWatcherEvent.watchUncompletedStarted()
                : const NoteWatcherEvent.watchAllStarted(),
          );
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: toggleState.value
              ? const Icon(
                  Icons.check_box_outline_blank,
                  key: Key('outline'),
                )
              : const Icon(
                  Icons.indeterminate_check_box,
                  key: Key('indeterminate'),
                ),
        ),
      ),
    );
  }
}
