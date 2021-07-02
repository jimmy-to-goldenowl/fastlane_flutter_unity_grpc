import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:loveblocks/models/result.dart';
import 'package:loveblocks/models/user.dart';
import 'package:loveblocks/src/dialogs/dialog_service.dart';

class AuthService {
  static final instance = AuthService._();
  factory AuthService() => instance;
  AuthService._();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final FirestoreService _firestore = FirestoreService.instance;

  final Logger log = Logger();

  Stream<User?> get userStream {
    return _firebaseAuth.authStateChanges().map((user) {
      return user;
    });
  }

  Future<Result<LUser>> loginWithEmail(
      {required String email, required String password}) async {
    try {
      final UserCredential user = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return _handleLogin(user.user, loginType: LoginType.email);
    } catch (e) {
      return Result.exception(e);
    }
  }

  Future<Result<LUser>> signUpWithEmail(
      {required String password, required String email}) async {
    try {
      final UserCredential user = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _handleLogin(user.user, loginType: LoginType.email);
    } catch (e) {
      return Result.exception(e);
    }
  }

  Future<Result<LUser>> loginWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      final bool isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        await _googleSignIn.signOut();
      }
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      final UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return _handleLogin(user.user, loginType: LoginType.google);
    } catch (e) {
      return Result.exception(e);
    }
  }

  Future<Result<LUser>> _handleLogin(User? user, {LoginType? loginType}) async {
    // set user with the Id if he does not exist
    // and update other fields but registrationComplete
    final uid = user?.uid;
    if (uid == null) {
      return Result.error('Create user failed');
    }
    final item = LUser.fromUserCredential(user!);
    return Result.success(item);
  }

  Future<Result<String>> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return Result.success(email);
    } catch (e) {
      return Result.exception(e);
    }
  }

  bool isUserLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  String? getUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  Future logOut() async {
    return showAlert(
        title: 'Logout',
        body: 'Are you sure you want to logout now?',
        actions: [
          DialogButton('Yes',
              key: Key('confirm_button'), onPressed: _firebaseAuth.signOut),
          DialogButton('No'),
        ]);
  }
}

enum LoginType {
  facebook,
  google,
  twitter,
  email,
  apple,
}
