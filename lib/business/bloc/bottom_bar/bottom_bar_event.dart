part of 'bottom_bar_bloc.dart';

abstract class BottomBarEvent extends Equatable {
  const BottomBarEvent();
}

class SwitchEvent extends BottomBarEvent {
  final int selectedIndex;

  const SwitchEvent(this.selectedIndex);

  @override
  List<int> get props => [selectedIndex];
}
