import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class Result<T> {
  T? data;
  String? error;

  bool get isError => error != null;
  bool get isSuccess => error == null && data != null;

  Result.success(this.data) {
    this.error = null;
  }

  Result.error(this.error) {
    this.data = null;
    error = 'An Unknown Error Occurred';
  }

  Result.exception(Object? e) {
    this.data = null;
    if (e is PlatformException) {
      error = e.message;
    } else if (e is AssertionError) {
      error = e.message?.toString();
    } else if (e is FirebaseAuthException) {
      error = e.message;
    } else if (e is FirebaseException) {
      error = e.message;
    }
    error ??= 'An Unknown Error Occurred';
  }
}
