import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

enum NameError { empty }

extension PasswordErrorMessage on NameError {
  String? messageOf(BuildContext context) {
    switch (this) {
      case NameError.empty:
        return "Name can't be empty";
      default:
        return null;
    }
  }
}

class Name extends FormzInput<String, NameError> {
  const Name.pure() : super.pure('');
  const Name.dirty([String value = '']) : super.dirty(value);

  @override
  NameError? validator(String? value) {
    if ((value ?? '').isEmpty) {
      return NameError.empty;
    }
    return null;
  }
}
