import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'color_event.dart';
part 'color_state.dart';

class ColorBloc extends Bloc<ColorEvent, ColorState> {
  ColorBloc() : super(ColorInitial()) {
    on<ColorChoise>((event, emit) {
      emit(ColorInitial());
      if (event.color != null) {
        emit(ColorChoised(event.color));
      } else {
        emit(const ColorChoised(Color.fromRGBO(144, 83, 235, 1.0)));
      }
    });
  }
}
