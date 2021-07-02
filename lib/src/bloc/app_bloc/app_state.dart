part of 'app_bloc.dart';

enum AppStatus {
  initial,
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.uid = '',
  });

  const AppState.initial() : this._(status: AppStatus.initial);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  const AppState.authenticated(String uid) : this._(status: AppStatus.authenticated, uid: uid);

  final AppStatus status;
  final String uid;

  @override
  List<Object> get props => [status, uid];
}
