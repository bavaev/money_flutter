part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthAwait extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthAuthentificated extends AuthState {
  final UserApp? user;
  final String? avatarUrl;

  const AuthAuthentificated(this.user, this.avatarUrl);

  @override
  List<dynamic> get props => [user, avatarUrl];
}

class AuthError extends AuthState {
  final String? error;

  const AuthError(this.error);

  @override
  List<String?> get props => [error];
}
