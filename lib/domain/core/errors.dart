import 'package:flutter_firebase_ddd_project/domain/core/failures.dart';

class NotAuthenticationError extends Error {}

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString() {
    final errorMessage =
        'Encountered a ValueFailure at an unrecoverable point. Terminating. Failure was: $valueFailure';
    return Error.safeToString(errorMessage);
  }
}
