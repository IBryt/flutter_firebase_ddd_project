import 'package:flutter_firebase_ddd_project/domain/auth/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required UniqueId id,
  }) = _AuthUser;
}
