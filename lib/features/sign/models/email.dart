import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

enum EmailError { empty, invalid }

extension PasswordErrorMessage on EmailError {
  String? messageOf(BuildContext context) {
    switch (this) {
      case EmailError.empty:
        return "Email can't be empty";
      case EmailError.invalid:
        return 'Invalid email';
      default:
        return null;
    }
  }
}

class Email extends FormzInput<String, EmailError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailError? validator(String? value) {
    if ((value ?? '').isEmpty) {
      return EmailError.empty;
    }
    return _emailRegExp.hasMatch(value ?? '') ? null : EmailError.invalid;
  }
}
