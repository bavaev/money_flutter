part of 'data_bloc.dart';

abstract class DataEvent extends Equatable {
  const DataEvent();
}

class GetData extends DataEvent {
  @override
  List<Object> get props => [];
}

class AddCategory extends DataEvent {
  final String category;
  final String color;
  final String owner;
  final Map<String, dynamic> expense;

  const AddCategory(this.category, this.color, this.owner, this.expense);

  @override
  List<dynamic> get props => [category, color, owner, expense];
}

class UpdateCategory extends DataEvent {
  final String id;
  final String category;
  final String color;
  final String owner;
  final Map<String, dynamic> expense;

  const UpdateCategory(this.id, this.category, this.color, this.owner, this.expense);

  @override
  List<dynamic> get props => [id, category, color, owner, expense];
}

class RemoveCategory extends DataEvent {
  final String id;

  const RemoveCategory(this.id);

  @override
  List<Object> get props => [id];
}

class RemoveAllData extends DataEvent {
  @override
  List<Object> get props => [];
}
