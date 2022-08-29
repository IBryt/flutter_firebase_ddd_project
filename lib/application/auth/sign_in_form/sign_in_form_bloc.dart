import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_ddd_project/domain/auth/auth_failure.dart';
import 'package:flutter_firebase_ddd_project/domain/auth/i_auth_facade.dart';
import 'package:flutter_firebase_ddd_project/domain/auth/value_objects.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

part 'sign_in_form_event.dart';

part 'sign_in_form_state.dart';

part 'sign_in_form_bloc.freezed.dart';

typedef _PerformActionOnAuth = Future<Either<AuthFailure, Unit>> Function({
  required EmailAddress emailAddress,
  required Password password,
});

class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<SignInFormEvent>(
      (event, emit) async => await _onSignInFormEvent(
        event,
        emit,
      ),
      transformer: sequential(),
    );
  }

  Future<void> _onSignInFormEvent(
    SignInFormEvent event,
    Emitter<SignInFormState> emit,
  ) async {
    await event.map(
      emailChanged: (_) async => await _onEmailChanged(event, emit),
      passwordChanged: (_) async => await _onPasswordChanged(event, emit),
      registerWithEmailAndPasswordPressed: (_) async =>
          await _onRegisterWithEmailAndPasswordPressed(event, emit),
      signInWithEmailAndPasswordPressed: (_) async =>
          await _onSignInWithEmailAndPasswordPressed(event, emit),
      signInWithGooglePressed: (_) async =>
          await _onSignInWithGooglePressed(event, emit),
    );
  }

  Future<void> _onEmailChanged(event, emit) async {
    emit(state.copyWith(
      emailAddress: EmailAddress(event.emailStr),
      authFailureOrSuccessOption: none(),
    ));
  }

  Future<void> _onPasswordChanged(event, emit) async {
    emit(state.copyWith(
      password: Password(event.passwordStr),
      authFailureOrSuccessOption: none(),
    ));
  }

  Future<void> _onRegisterWithEmailAndPasswordPressed(event, emit) async {
    await _performActionOnAuthFacadeWithEmailAndPassword(
      emit,
      _authFacade.registerWithEmailAndPassword,
    );
  }

  Future<void> _onSignInWithEmailAndPasswordPressed(event, emit) async {
    await _performActionOnAuthFacadeWithEmailAndPassword(
      emit,
      _authFacade.signInWithEmailAndPassword,
    );
  }

  Future<void> _onSignInWithGooglePressed(event, emit) async {
    emit(state.copyWith(
      isSubmitting: true,
      authFailureOrSuccessOption: none(),
    ));
    final failureOrSuccess = await _authFacade.signInWithGoogle();
    emit(
      state.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: some(failureOrSuccess)),
    );
  }

  Future<void> _performActionOnAuthFacadeWithEmailAndPassword(
    Emitter<SignInFormState> emit,
    _PerformActionOnAuth forwardedCall,
  ) async {
    Either<AuthFailure, Unit>? failureOrSuccess;

    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      ));

      failureOrSuccess = await forwardedCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }
    emit(state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }
}
