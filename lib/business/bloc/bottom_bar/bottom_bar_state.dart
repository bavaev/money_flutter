part of 'bottom_bar_bloc.dart';

abstract class BottomBarState extends Equatable {
  const BottomBarState();

  @override
  List<Object> get props => [];
}

class BottomBarExpenses extends BottomBarState {}

class BottomBarProfile extends BottomBarState {}
