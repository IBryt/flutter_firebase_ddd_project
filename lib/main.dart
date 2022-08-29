import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ddd_project/injection.dart' as injection;
import 'package:flutter_firebase_ddd_project/presentation/core/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  injection.configureInjection();
  runApp(const AppWidget());
}
