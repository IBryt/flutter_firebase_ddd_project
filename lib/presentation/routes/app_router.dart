import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ddd_project/application/auth/auth_bloc.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/note.dart';
import 'package:flutter_firebase_ddd_project/presentation/error/error_page.dart';
import 'package:flutter_firebase_ddd_project/presentation/loading/loading_page.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/note_form/note_form_page.dart';
import 'package:flutter_firebase_ddd_project/presentation/notes/notes_overview/notes_overview_page.dart';
import 'package:flutter_firebase_ddd_project/presentation/routes/route_names.dart';
import 'package:flutter_firebase_ddd_project/presentation/sign_in/sign_in_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final AuthBloc authBloc;
  Stream<AuthState>? stream;

  AppRouter(this.authBloc);

  GoRouter get router => GoRouter(
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      debugLogDiagnostics: kDebugMode ? true : false,
      urlPathStrategy: UrlPathStrategy.path,
      routes: [
        GoRoute(
          name: rootRouteName,
          path: '/',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const LoadingPage(),
          ),
        ),
        GoRoute(
          name: loginRouteName,
          path: '/login',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const SignInPage(),
          ),
        ),
        GoRoute(
          name: homeRouteName,
          path: '/home',
          redirect: (state) => state.namedLocation(
            noteRouteName,
          ),
        ),
        GoRoute(
          name: noteRouteName,
          path: '/note',
          pageBuilder: (context, state) {
            return MaterialPage<void>(
              key: state.pageKey,
              child: const NotesOverviewPage(),
            );
          },
          routes: [
            GoRoute(
              name: noteFormRouteName,
              path: 'form',
              pageBuilder: (context, state) {
                final editedNote = state.extra as Note?;
                return MaterialPage<void>(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: NoteFormPage(editedNote: editedNote),
                );
              },
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => ErrorPage(state.error!),
      redirect: (state) {
        final loginLoc = state.namedLocation(loginRouteName);
        final homeLoc = state.namedLocation(homeRouteName);
        final rootLoc = state.namedLocation(rootRouteName);

        final isRoot = state.subloc == rootLoc;
        final isLoggingIn = state.subloc == loginLoc;
        final isHome = state.subloc == homeLoc;

        final isAuthenticated =
            authBloc.state == const AuthState.authenticated();
        final isUnauthenticated =
            authBloc.state == const AuthState.unauthenticated();
        if (isUnauthenticated && !isLoggingIn) return loginLoc;
        if (!isHome && isAuthenticated && (isRoot || isLoggingIn)) {
          return homeLoc;
        }

        return null;
      });
}
