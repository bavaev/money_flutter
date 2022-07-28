import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:personal_accounting/business/bloc/data/data_bloc.dart';
import 'package:personal_accounting/business/functions/handles.dart';
import 'package:personal_accounting/business/models/category.dart';
import 'package:personal_accounting/ui/components/confirm_delete.dart';

class Expenses extends StatefulWidget {
  final Category category;
  const Expenses({Key? key, required this.category}) : super(key: key);

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  bool remove = false;
  Timestamp? timestamp;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ru');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        backgroundColor: categoryColor(widget.category.color.toString()),
        title: Text(
          widget.category.category.toString(),
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: SafeArea(child: BlocBuilder<DataBloc, DataState>(
        builder: (context, state) {
          if (state is Data) {
            final Category category = list(state.categories, widget.category.id.toString());
            Map<String, dynamic> listExpenses = category.expense ?? {};
            return ListView.builder(
              itemCount: listExpenses.length,
              itemBuilder: (BuildContext context, int index) {
                String expense = listExpenses.keys.elementAt(index);
                return GestureDetector(
                  onLongPress: () => setState(() {
                    remove = !remove;
                    timestamp = listExpenses[expense];
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
                                expense,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Text(
                                '${DateFormat.yMMMMd('ru').format(DateTime.fromMillisecondsSinceEpoch(listExpenses[expense].seconds * 1000))} / ${DateFormat.Hm('ru').format(DateTime.fromMillisecondsSinceEpoch(listExpenses[expense].seconds * 1000))}',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
                          ),
                        ),
                        remove && listExpenses[expense] == timestamp
                            ? GestureDetector(
                                onTap: () {
                                  listExpenses.removeWhere((key, value) => value == timestamp);
                                  showConfirmDeleteDialog(
                                    context: context,
                                    type: 'expense',
                                    category: Category(
                                      id: category.id.toString(),
                                      category: category.category.toString(),
                                      color: category.color.toString(),
                                      owner: category.owner.toString(),
                                      expense: listExpenses,
                                    ),
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
                            : const SizedBox(),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      )),
    );
  }
}
