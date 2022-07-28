import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:personal_accounting/business/models/category.dart';
import 'package:personal_accounting/data/repository.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  RepositoryFirestore repository;

  DataBloc(this.repository) : super(DataInitial()) {
    on<GetData>((event, emit) async {
      repository.data();
      await emit.onEach(
        repository.dataStateStream,
        onData: (List<Category> categories) {
          emit(DataInitial());
          emit(Data(categories));
        },
      );
    });
    on<AddCategory>((event, emit) {
      repository.add(Category(category: event.category, color: event.color, owner: event.owner));
    });
    on<UpdateCategory>((event, emit) {
      repository.update(Category(id: event.id, category: event.category, color: event.color, owner: event.owner, expense: event.expense));
    });
    on<RemoveCategory>((event, emit) {
      repository.remove(event.id);
    });
    on<RemoveAllData>((event, emit) {
      emit(DataInitial());
      repository.deleteAllData();
    });
  }

  void dispose() {
    repository.dispose();
  }
}
