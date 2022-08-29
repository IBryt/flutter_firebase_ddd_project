import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_firebase_ddd_project/domain/auth/i_auth_facade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.dart';

part 'auth_state.dart';

part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;

  AuthBloc(this._authFacade) : super(const AuthState.initial()) {
    on<AuthEvent>(
      (event, emit) async => await _onAuthEvent(event, emit),
      transformer: sequential(),
    );
  }

  Future<void> _onAuthEvent(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    await event.map(
      authCheckRequested: (_) async => await _onAuthCheckRequested(event, emit),
      signedOut: (_) async => await _onSignedOut(event, emit),
    );
  }

  Future<void> _onAuthCheckRequested(event, emit) async {
    final userOption = _authFacade.getSingedInUser();
    emit(
      userOption.fold(
        () => const AuthState.unauthenticated(),
        (_) => const AuthState.authenticated(),
      ),
    );
  }

  Future<void> _onSignedOut(event, emit) async {
    await _authFacade.signOut();
    emit(const AuthState.unauthenticated());
  }
}
