import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

enum PhoneError { empty, invalid }

extension PasswordErrorMessage on PhoneError {
  String? messageOf(BuildContext context) {
    switch (this) {
      case PhoneError.empty:
        return "Phone can't be empty";
      case PhoneError.invalid:
        return 'Invalid phone';
      default:
        return null;
    }
  }
}

class Phone extends FormzInput<String, PhoneError> {
  const Phone.pure() : super.pure('');
  const Phone.dirty([String value = '']) : super.dirty(value);

  static final RegExp _phoneRegExp = RegExp(r'[0-9]{10,12}');

  @override
  PhoneError? validator(String? value) {
    if ((value ?? '').isEmpty) {
      return PhoneError.empty;
    }
    return _phoneRegExp.hasMatch(value ?? '') ? null : PhoneError.invalid;
  }
}
