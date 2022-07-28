part of 'color_bloc.dart';

abstract class ColorEvent extends Equatable {
  const ColorEvent();
}

class ColorChoise extends ColorEvent {
  final Color? color;

  const ColorChoise(this.color);

  @override
  List<Color?> get props => [color];
}
