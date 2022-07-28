part of 'date_bloc.dart';

abstract class DateEvent extends Equatable {
  const DateEvent();
}

class DateChange extends DateEvent {
  final DateTime? date;

  const DateChange(this.date);

  @override
  List<DateTime?> get props => [date];
}
