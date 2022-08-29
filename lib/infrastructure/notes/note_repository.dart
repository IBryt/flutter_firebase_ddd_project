import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/i_note_repository.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/note.dart';
import 'package:flutter_firebase_ddd_project/domain/notes/note_failure.dart';
import 'package:flutter_firebase_ddd_project/infrastructure/notes/note_dtos.dart';
import 'package:flutter_firebase_ddd_project/infrastructure/core/firestore_helpers.dart';
import 'package:kt_dart/kt.dart';
import 'package:rxdart/rxdart.dart';

class NoteRepository implements INoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepository(this._firestore);

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() {
    return _firestore
        .userDocument()
        .noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map(
          (snapshots) => right<NoteFailure, KtList<Note>>(
            snapshots.docs
                .map((doc) => NoteDTO.fromFirestore(doc).toDomain())
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith((error, stackTrace) {
      if (error is FirebaseException &&
          (error.message?.contains('PERMISSION_DENIED') ?? false)) {
        return left<NoteFailure, KtList<Note>>(
          const NoteFailure.insufficientPermission(),
        );
      } else {
        return left<NoteFailure, KtList<Note>>(
          const NoteFailure.unexpected(),
        );
      }
    });
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted() {
    return _firestore
        .userDocument()
        .noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map(
          (snapshots) => snapshots.docs
              .map((doc) => NoteDTO.fromFirestore(doc).toDomain()),
        )
        .map((notes) => right<NoteFailure, KtList<Note>>(notes
            .where((note) =>
                note.todos.getOrCrash().any((todoItem) => !todoItem.done))
            .toImmutableList()))
        .onErrorReturnWith((error, stackTrace) {
      if (error is FirebaseException &&
          (error.message?.contains('PERMISSION_DENIED') ?? false)) {
        return left<NoteFailure, KtList<Note>>(
          const NoteFailure.insufficientPermission(),
        );
      } else {
        return left<NoteFailure, KtList<Note>>(
          const NoteFailure.unexpected(),
        );
      }
    });
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final userDoc = _firestore.userDocument();
      final noteDTO = NoteDTO.fromDomain(note);
      await userDoc.noteCollection.doc(noteDTO.id).set(noteDTO.toJson());
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final userDoc = _firestore.userDocument();
      final noteDTO = NoteDTO.fromDomain(note);
      await userDoc.noteCollection.doc(noteDTO.id).update(noteDTO.toJson());
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e.message?.contains('NOT_FOUND') ?? false) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final userDoc = _firestore.userDocument();
      final noteId = note.id.getOrCrash();
      await userDoc.noteCollection.doc(noteId).delete();
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e.message?.contains('NOT_FOUND') ?? false) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }
}
