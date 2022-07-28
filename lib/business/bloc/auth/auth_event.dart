part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthRegistration extends AuthEvent {
  final String email;
  final String password;

  const AuthRegistration(this.email, this.password);

  @override
  List<String> get props => [email, password];
}

class AuthCheckStatus extends AuthEvent {
  @override
  List<UserApp?> get props => [];
}

class AuthAuthentification extends AuthEvent {
  final String email;
  final String password;

  const AuthAuthentification(this.email, this.password);

  @override
  List<String> get props => [email, password];
}

class AuthSignout extends AuthEvent {
  @override
  List<Object> get props => [];
}
