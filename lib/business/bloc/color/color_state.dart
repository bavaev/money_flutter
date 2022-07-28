part of 'color_bloc.dart';

abstract class ColorState extends Equatable {
  const ColorState();
}

class ColorInitial extends ColorState {
  @override
  List<Object> get props => [];
}

class ColorChoised extends ColorState {
  final Color? color;

  const ColorChoised(this.color);

  @override
  List<Color?> get props => [color];
}
