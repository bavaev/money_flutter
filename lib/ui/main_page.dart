import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:personal_accounting/business/bloc/bottom_bar/bottom_bar_bloc.dart';
import 'package:personal_accounting/ui/category/categories.dart';
import 'package:personal_accounting/ui/profile/profile.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomBarBloc, BottomBarState>(
      builder: (context, state) {
        if (state is BottomBarExpenses) {
          return const Categories();
        } else {
          return const Profile();
        }
      },
    );
  }
}
