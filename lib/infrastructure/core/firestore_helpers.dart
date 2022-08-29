import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_ddd_project/domain/auth/i_auth_facade.dart';
import 'package:flutter_firebase_ddd_project/domain/core/errors.dart';
import 'package:flutter_firebase_ddd_project/injection.dart' as injection;

extension FirestoreX on FirebaseFirestore {
  DocumentReference userDocument() {
    final userOption = injection.get<IAuthFacade>().getSingedInUser();
    final user = userOption.getOrElse(() => throw NotAuthenticationError());
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id.getOrCrash());
  }
}

extension DocumentReferenses on DocumentReference {
  CollectionReference get noteCollection => collection('notes');
}
