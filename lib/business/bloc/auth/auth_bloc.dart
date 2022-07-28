import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:personal_accounting/business/bloc/data/data_bloc.dart';

import 'package:personal_accounting/business/models/user.dart';
import 'package:personal_accounting/data/repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RepositoryFirestore repository;
  final DataBloc data;

  AuthBloc(this.repository, this.data) : super(AuthInitial()) {
    on<AuthCheckStatus>((event, emit) async {
      repository.auth();
      await emit.onEach(
        repository.authStateStream,
        onData: (UserApp? user) {
          if (user != null) {
            emit(AuthAuthentificated(UserApp(id: user.id, email: user.email), repository.getAvatar()));
            data.add(GetData());
          }
        },
      );
    });
    on<AuthRegistration>((event, emit) async {
      emit(AuthAwait());
      String? answer;
      answer = await repository.registration(event.email, event.password);
      if (answer == 'The password provided is too weak.' || answer == 'The account already exists for that email.') {
        emit(AuthError(answer));
      }
    });
    on<AuthAuthentification>((event, emit) async {
      emit(AuthAwait());
      String? answer;
      answer = await repository.login(event.email, event.password);
      if (answer == 'email not found' || answer == 'wrong password') {
        emit(AuthError(answer));
      }
    });
    on<AuthSignout>((event, emit) async {
      emit(AuthAwait());
      await repository.signOut();
      emit(AuthInitial());
    });
  }

  void dispose() {
    repository.dispose();
  }
}
