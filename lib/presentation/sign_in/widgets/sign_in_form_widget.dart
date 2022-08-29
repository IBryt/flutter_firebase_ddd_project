import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/auth/auth_bloc.dart';
import 'package:flutter_firebase_ddd_project/application/auth/sign_in_form/sign_in_form_bloc.dart';

class SignInFormWidget extends StatelessWidget {
  const SignInFormWidget({Key? key}) : super(key: key);

  void _handleListener(BuildContext context, SignInFormState state) {
    state.authFailureOrSuccessOption.fold(
      () {},
      (either) => either.fold(
        (f) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              f.map(
                cancelledByUser: (_) => 'Cancelled',
                serverError: (_) => 'Server error',
                emailAlreadyInUse: (_) => 'Email already in use',
                invalidEmailAndPasswordCombination: (_) =>
                    'Invalid email and password combination',
              ),
            ),
          ),
        ),
        (r) {
          final authBloc = context.read<AuthBloc>();
          authBloc.add(const AuthEvent.authCheckRequested());
          //context.goNamed(rootRouteName);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) => _handleListener(context, state),
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(8.0),
          children: const [
            _HeaderWidget(),
            SizedBox(height: 8.0),
            _FormWidget(),
            SizedBox(height: 8.0),
            _ButtonBasicAuthWidget(),
            _ButtonGoogleAuthWidget(),
            _SubmittingProgressIndicatorWidget(),
          ],
        );
      },
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '📝',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 130),
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        shrinkWrap: true,
        children: const [
          _EmailInputWidget(),
          SizedBox(height: 8.0),
          _PasswordInputWidget(),
        ],
      ),
    );
  }
}

class _EmailInputWidget extends StatelessWidget {
  const _EmailInputWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? _validatorEmail(SignInFormState state) {
      if (!state.showErrorMessages) {
        return null;
      }
      return state.emailAddress.value.fold(
        (f) => f.maybeMap(
          invalidEmail: (_) => 'Invalid Email',
          orElse: () => null,
        ),
        (r) => null,
      );
    }

    return BlocBuilder<SignInFormBloc, SignInFormState>(
      buildWhen: (previous, current) =>
          previous.emailAddress != current.emailAddress ||
          previous.showErrorMessages != current.showErrorMessages,
      builder: (context, state) {
        return TextFormField(
          validator: (value) => _validatorEmail(state),
          onChanged: (value) => context
              .read<SignInFormBloc>()
              .add(SignInFormEvent.emailChanged(value)),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email),
            labelText: 'Email',
            errorText: _validatorEmail(state),
          ),
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }
}

class _PasswordInputWidget extends StatelessWidget {
  const _PasswordInputWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? _validatorPassword(SignInFormState state) {
      if (!state.showErrorMessages) {
        return null;
      }
      return state.password.value.fold(
        (f) => f.maybeMap(
          shortPassword: (_) => 'Invalid Password',
          orElse: () => null,
        ),
        (r) => null,
      );
    }

    return BlocBuilder<SignInFormBloc, SignInFormState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.showErrorMessages != current.showErrorMessages,
      builder: (context, state) {
        return TextFormField(
          validator: (value) => _validatorPassword(state),
          onChanged: (value) => context
              .read<SignInFormBloc>()
              .add(SignInFormEvent.passwordChanged(value)),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock),
            labelText: 'password',
            errorText: _validatorPassword(state),
          ),
          autocorrect: false,
          //obscureText: true,
        );
      },
    );
  }
}

class _ButtonBasicAuthWidget extends StatelessWidget {
  const _ButtonBasicAuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signInFormBloc = context.watch<SignInFormBloc>();
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              signInFormBloc.add(
                const SignInFormEvent.signInWithEmailAndPasswordPressed(),
              );
            },
            child: const Text('SIGN IN'),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              signInFormBloc.add(
                const SignInFormEvent.registerWithEmailAndPasswordPressed(),
              );
            },
            child: const Text('REGISTER'),
          ),
        ),
      ],
    );
  }
}

class _ButtonGoogleAuthWidget extends StatelessWidget {
  const _ButtonGoogleAuthWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signInFormBloc = context.watch<SignInFormBloc>();
    return ElevatedButton(
      onPressed: () {
        signInFormBloc.add(
          const SignInFormEvent.signInWithGooglePressed(),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
      ),
      child: const Text(
        'SIGN IN GOOGLE',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SubmittingProgressIndicatorWidget extends StatelessWidget {
  const _SubmittingProgressIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSubmitting =
        context.select((SignInFormBloc value) => value.state.isSubmitting);
    return isSubmitting
        ? const LinearProgressIndicator()
        : const SizedBox.shrink();
  }
}
