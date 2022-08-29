import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_project/domain/auth/auth_failure.dart';
import 'package:flutter_firebase_ddd_project/domain/auth/auth_user.dart';
import 'package:flutter_firebase_ddd_project/domain/auth/value_objects.dart';

abstract class IAuthFacade {
  Option<AuthUser> getSingedInUser();

  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithGoogle();

  Future<void> signOut();
}
