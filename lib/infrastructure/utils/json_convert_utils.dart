import 'package:cloud_firestore/cloud_firestore.dart';

@override
FieldValue serverTimestampFromJson(Object json) => FieldValue.serverTimestamp();

@override
Object serverTimestampToJson(FieldValue field) => field;
