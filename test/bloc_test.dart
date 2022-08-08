import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:personal_accounting/business/bloc/auth/auth_bloc.dart';
import 'package:personal_accounting/business/bloc/color/color_bloc.dart';
import 'package:personal_accounting/business/bloc/data/data_bloc.dart';
import 'package:personal_accounting/business/bloc/date/date_bloc.dart';
import 'package:personal_accounting/data/repository.dart';

void main() {
  final RepositoryFirestore repository = RepositoryFirestore();
  final DataBloc data = DataBloc(repository);
  final _dateNow = DateTime.now();

  blocTest<AuthBloc, AuthState>(
    'Auth Bloc',
    build: () => AuthBloc(repository, data),
    act: (bloc) => bloc.add(const AuthRegistration('test', 'test')),
    expect: () => <AuthState>[AuthAwait()],
  );

  blocTest<DateBloc, DateState>(
    'Date Bloc',
    build: () => DateBloc(),
    act: (bloc) => bloc.add(DateChange(_dateNow)),
    expect: () => <DateState>[DateInitial(), DateNow(_dateNow)],
  );

  blocTest<ColorBloc, ColorState>(
    'Color Bloc',
    build: () => ColorBloc(),
    act: (bloc) => bloc.add(const ColorChoise(Colors.red)),
    expect: () => <ColorState>[ColorInitial(), const ColorChoised(Colors.red)],
  );
}
