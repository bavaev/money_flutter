part of 'date_bloc.dart';

abstract class DateState extends Equatable {
  const DateState();
}

class DateInitial extends DateState {
  @override
  List<Object> get props => [];
}

class DateNow extends DateState {
  final DateTime? dateNow;

  const DateNow(this.dateNow);

  @override
  List<DateTime?> get props => [dateNow];
}
