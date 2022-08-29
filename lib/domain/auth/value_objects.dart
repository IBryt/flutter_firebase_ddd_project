import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_project/domain/core/failures.dart';
import 'package:flutter_firebase_ddd_project/domain/core/value_objects.dart';
import 'package:flutter_firebase_ddd_project/domain/core/value_validators.dart';
import 'package:uuid/uuid.dart';

class EmailAddress extends ValueObject<String> {
  const EmailAddress._(this.value);

  factory EmailAddress(String input) {
    return EmailAddress._(
      validateEmailAddress(input),
    );
  }

  @override
  final Either<ValueFailure<String>, String> value;
}

class Password extends ValueObject<String> {
  const Password._(this.value);

  factory Password(String input) {
    return Password._(
      validatePassword(input),
    );
  }

  @override
  final Either<ValueFailure<String>, String> value;
}

class UniqueId extends ValueObject<String> {
  const UniqueId._(this.value);

  factory UniqueId() {
    return UniqueId._(right(const Uuid().v1()));
  }

  factory UniqueId.fromUniqueString(String uniqueId) {
    return UniqueId._(
      right(uniqueId),
    );
  }

  @override
  final Either<ValueFailure<String>, String> value;
}
