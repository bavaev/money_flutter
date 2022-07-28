import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:personal_accounting/business/bloc/bottom_bar/bottom_bar_bloc.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      context.read<BottomBarBloc>().add(SwitchEvent(index));
    }

    return BlocBuilder<BottomBarBloc, BottomBarState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state is BottomBarExpenses ? 0 : 1,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card_outlined),
              label: 'Расходы',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль',
            ),
          ],
        );
      },
    );
  }
}
