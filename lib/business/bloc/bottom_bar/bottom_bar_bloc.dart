import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_bar_event.dart';
part 'bottom_bar_state.dart';

class BottomBarBloc extends Bloc<BottomBarEvent, BottomBarState> {
  BottomBarBloc() : super(BottomBarExpenses()) {
    on<SwitchEvent>((event, emit) {
      if (event.selectedIndex == 0) {
        emit(BottomBarExpenses());
      } else {
        emit(BottomBarProfile());
      }
    });
  }
}
