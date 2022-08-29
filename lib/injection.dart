import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_ddd_project/application/auth/auth_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/notes/note_actor/note_actor_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/notes/note_form/note_form_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:flutter_firebase_ddd_project/domain/auth/i_auth_facade.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/i_note_repository.dart';
import 'package:flutter_firebase_ddd_project/infrastructure/auth/firebase_auth_facade.dart';
import 'package:flutter_firebase_ddd_project/infrastructure/notes/note_repository.dart';
import 'package:flutter_firebase_ddd_project/presentation/routes/app_router.dart';

import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _getIt = GetIt.instance;

T get<T extends Object>() {
  return _getIt<T>();
}

void configureInjection() {
  // Core
  _getIt.registerLazySingleton<AppRouter>(() => AppRouter(get<AuthBloc>()));

  // Common
  _getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  // Auth
  _getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  _getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  _getIt.registerLazySingleton<IAuthFacade>(() => FirebaseAuthFacade(
        get<FirebaseAuth>(),
        get<GoogleSignIn>(),
      ));

  // Blocs
  _getIt.registerFactory<SignInFormBloc>(
      () => SignInFormBloc(get<IAuthFacade>()));
  _getIt.registerLazySingleton<AuthBloc>(() => AuthBloc(get<IAuthFacade>()));
  _getIt.registerFactory<NoteWatcherBloc>(
      () => NoteWatcherBloc(get<INoteRepository>()));
  _getIt.registerFactory<NoteActorBloc>(
      () => NoteActorBloc(get<INoteRepository>()));
  _getIt.registerFactory<NoteFormBloc>(
      () => NoteFormBloc(get<INoteRepository>()));

  //Repository
  _getIt.registerLazySingleton<INoteRepository>(() => NoteRepository(
        get<FirebaseFirestore>(),
      ));
}
