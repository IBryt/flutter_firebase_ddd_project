import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/auth/auth_bloc.dart';
import 'package:flutter_firebase_ddd_project/injection.dart' as injection;
import 'package:flutter_firebase_ddd_project/presentation/routes/app_router.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = injection.get<AppRouter>().router;

    return BlocProvider(
      create: (_) =>
          injection.get<AuthBloc>()..add(const AuthEvent.authCheckRequested()),
      lazy: false,
      child: MaterialApp.router(
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        title: 'Notes',
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.green[800],
          colorScheme: ThemeData.light().colorScheme.copyWith(
              primary: Colors.green[800], secondary: Colors.blueAccent),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue[900],
          ),
        ),
      ),
    );
  }
}
