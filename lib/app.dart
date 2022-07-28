import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:personal_accounting/business/bloc/auth/auth_bloc.dart';
import 'package:personal_accounting/business/bloc/bottom_bar/bottom_bar_bloc.dart';
import 'package:personal_accounting/business/bloc/color/color_bloc.dart';
import 'package:personal_accounting/business/bloc/data/data_bloc.dart';
import 'package:personal_accounting/business/bloc/date/date_bloc.dart';
import 'package:personal_accounting/business/bloc/image/image_bloc.dart';
import 'package:personal_accounting/data/repository.dart';
import 'package:personal_accounting/data/storage.dart';
import 'package:personal_accounting/global/theme.dart';
import 'package:personal_accounting/ui/login/login.dart';
import 'package:personal_accounting/ui/main_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<RepositoryFirestore>(
      create: (_) => RepositoryFirestore(),
      child: RepositoryProvider<RepositoryStorage>(
        create: (__) => RepositoryStorage(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<DataBloc>(
              create: (_) => DataBloc(RepositoryProvider.of(_)),
            ),
            BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(RepositoryProvider.of(_), _.read<DataBloc>())..add(AuthCheckStatus()),
            ),
            BlocProvider<BottomBarBloc>(
              create: (_) => BottomBarBloc(),
            ),
            BlocProvider<ColorBloc>(
              create: (_) => ColorBloc(),
            ),
            BlocProvider<DateBloc>(
              create: (_) => DateBloc(),
            ),
            BlocProvider<ImageBloc>(
              create: (__) => ImageBloc(RepositoryProvider.of(__)),
            ),
          ],
          child: MaterialApp(
            title: 'Личная бухгалтерия',
            theme: themeLight,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (BuildContext context, state) {
                return state is AuthAuthentificated ? const MainPage() : const LoginPage();
              },
            ),
          ),
        ),
      ),
    );
  }
}
