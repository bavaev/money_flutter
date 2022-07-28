import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'date_event.dart';
part 'date_state.dart';

class DateBloc extends Bloc<DateEvent, DateState> {
  DateBloc() : super(DateInitial()) {
    on<DateChange>((event, emit) {
      emit(DateInitial());
      if (event.date != null) {
        emit(DateNow(event.date));
      } else {
        emit(DateNow(DateTime.now()));
      }
    });
  }
}
