import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_firebase_ddd_project/domain/auth/auth_user.dart';
import 'package:flutter_firebase_ddd_project/domain/auth/value_objects.dart';

extension FirebaseUserDomainX on firebase.User {
  AuthUser toDomain() {
    return AuthUser(
      id: UniqueId.fromUniqueString(uid),
    );
  }
}
