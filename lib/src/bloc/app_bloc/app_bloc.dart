import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:loveblocks/services/auth_service.dart';
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState.initial()) {
    _userSubscription = _authService.userStream.listen(_onUserChanged);
  }
  final AuthService _authService = AuthService.instance;
  late final StreamSubscription<User?> _userSubscription;

  void _onUserChanged(User? user) => add(AppUserChanged(user));
  bool get isAuthenticated => state.status == AppStatus.authenticated;
  bool get isUnauthenticated => state.status == AppStatus.unauthenticated;
  bool get isInitial => state.status == AppStatus.initial;

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppUserChanged) {
      yield await _mapUserChangedToState(event, state);
    } else if (event is AppLogoutRequested) {
      _authService.logOut();
    }
  }

  Future<AppState> _mapUserChangedToState(
      AppUserChanged event, AppState state) async {
    final String? uid = event.user?.uid;
    if (uid != null) {
      return AppState.authenticated(uid);
    } else {
      return const AppState.unauthenticated();
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
