import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:personal_accounting/business/bloc/data/data_bloc.dart';
import 'package:personal_accounting/business/functions/handles.dart';
import 'package:personal_accounting/ui/category/expenses.dart';
import 'package:personal_accounting/ui/components/add_expense.dart';
import 'package:personal_accounting/ui/components/confirm_delete.dart';

class ListCategories extends StatefulWidget {
  const ListCategories({Key? key}) : super(key: key);

  @override
  State<ListCategories> createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  bool remove = false;
  String? categoryId;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ru');
    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        if (state is Data) {
          return ListView.builder(
            itemCount: state.categories.length,
            itemBuilder: (BuildContext context, int index) {
              String sum = 'Добавить расход';
              if (state.categories[index].expense != null) {
                sum = expenses(state.categories[index].expense!.keys.toList()).toString();
              }
              return GestureDetector(
                onTap: () {
                  showAddExpense(
                    context: context,
                    category: state.categories[index],
                  );
                },
                onLongPress: () => setState(() {
                  remove = !remove;
                  categoryId = state.categories[index].id;
                }),
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: const Offset(-3, 3),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.categories[index].category.toString(),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(
                              sum,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                      remove && categoryId == state.categories[index].id
                          ? GestureDetector(
                              onTap: () {
                                showConfirmDeleteDialog(
                                  context: context,
                                  type: 'category',
                                  categoryId: state.categories[index].id.toString(),
                                  nameCategory: state.categories[index].category,
                                );
                              },
                              child: Container(
                                width: 120,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(243, 105, 105, 1.0),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Удалить',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 30,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return Expenses(category: state.categories[index]);
                                      },
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.arrow_forward_ios),
                                color: categoryColor(state.categories[index].color.toString()),
                                iconSize: 40,
                              ),
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
