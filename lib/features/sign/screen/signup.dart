import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:loveblocks/features/sign/bloc/login_cubit.dart';
import 'package:loveblocks/features/sign/widgets/sign_form.dart';
import 'package:loveblocks/src/dialogs/toast_wrapper.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Sign up')),
        body: buildForm(context),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Toast.show(state.message ?? 'Authentication Failure');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0),
              EmailInput(),
              const SizedBox(height: 8.0),
              PasswordInput(),
              const SizedBox(height: 8.0),
              RegisterButton(),
              const SizedBox(height: 8.0),
              GoogleLoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}
