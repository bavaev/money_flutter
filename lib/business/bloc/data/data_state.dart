part of 'data_bloc.dart';

abstract class DataState extends Equatable {
  const DataState();
}

class DataInitial extends DataState {
  @override
  List<Object> get props => [];
}

class Data extends DataState {
  final List<Category> categories;

  const Data(this.categories);

  @override
  List<Object> get props => [categories];
}
