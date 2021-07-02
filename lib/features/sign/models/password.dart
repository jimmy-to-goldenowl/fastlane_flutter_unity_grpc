import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

enum PasswordError { empty, invalid }

extension PasswordErrorMessage on PasswordError {
  String? messageOf(BuildContext context) {
    switch (this) {
      case PasswordError.empty:
        return "Password can't be empty";
      case PasswordError.invalid:
        return 'Invalid password';
      default:
        return null;
    }
  }
}

class Password extends FormzInput<String, PasswordError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordError? validator(String? value) {
    if ((value ?? '').isEmpty) {
      return PasswordError.empty;
    }
    return _passwordRegExp.hasMatch(value ?? '') ? null : PasswordError.invalid;
  }
}
