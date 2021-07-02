import 'package:beamer/beamer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:loveblocks/features/sign/models/email.dart';
import 'package:loveblocks/features/sign/models/password.dart';
import 'package:loveblocks/models/result.dart';
import 'package:loveblocks/models/user.dart';
import 'package:loveblocks/src/dialogs/dialog_service.dart';
import 'package:loveblocks/src/dialogs/toast_wrapper.dart';
import 'package:loveblocks/services/auth_service.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService _authService = AuthService.instance;
  LoginCubit() : super(const LoginState());
  Future signUpWithEmail() async {
    if (!state.status.isValidated) {
      return;
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    final email = state.email.value;
    final password = state.password.value;
    final Result<LUser> result =
        await _authService.signUpWithEmail(email: email, password: password);
    return loginDecision(result);
  }

  Future loginWithEmail() async {
    if (!state.status.isValidated) {
      return;
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    final email = state.email.value;
    final password = state.password.value;
    final result = await _authService.loginWithEmail(email: email, password: password);
    return loginDecision(result);
  }

  Future loginWithGoogle() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    final result = await _authService.loginWithGoogle();
    return loginDecision(result);
  }

  Future loginDecision(Result<LUser> result) async {
    if (result.isSuccess) {
      emit(state.copyWithSuccess());
    } else {
      emit(state.copyWithFailure(error: result.error));
    }
  }

  Future forgotPassword(BuildContext context, String email) async {
    final Result result = await _authService.forgotPassword(email);
    if (result.isError) {
      Toast.show(result.error);
    } else {
      context.beamBack();
      showAlert(body: 'We have e-mailed your password reset link.');
    }
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }
}
