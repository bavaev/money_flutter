import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:personal_accounting/business/bloc/data/data_bloc.dart';
import 'package:personal_accounting/business/bloc/date/date_bloc.dart';
import 'package:personal_accounting/business/functions/string_extension.dart';
import 'package:personal_accounting/business/models/category.dart';

Future showAddExpense({
  required BuildContext context,
  required Category category,
}) async {
  return await showDialog(
      context: context,
      builder: (context) => _AddExpenseDialog(
            category: category,
          ));
}

class _AddExpenseDialog extends StatefulWidget {
  const _AddExpenseDialog({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  State<_AddExpenseDialog> createState() => __AddExpenseDialogState();
}

class __AddExpenseDialogState extends State<_AddExpenseDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _expense = TextEditingController();
  DateTime? dateNow = DateTime.now();

  @override
  void didChangeDependencies() {
    context.read<DateBloc>().add(DateChange(dateNow));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        margin: const EdgeInsets.all(30),
        width: double.infinity,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FittedBox(
                  child: Text(
                    'Добавить расход',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Выберите дату',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      FittedBox(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            BlocBuilder<DateBloc, DateState>(
                                              builder: (context, state) {
                                                return state is DateNow
                                                    ? Text(
                                                        '${DateFormat.yMMMd('ru').format(state.dateNow!)}, ${DateFormat.E('ru').format(state.dateNow!).capitalize()}',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 30,
                                                        ),
                                                      )
                                                    : const CircularProgressIndicator();
                                              },
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            const Icon(
                                              Icons.calendar_today,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      dateNow = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                      );
                                      if (!mounted) return;
                                      setState(() => dateNow);
                                      context.read<DateBloc>().add(DateChange(dateNow));
                                    },
                                    child: const FittedBox(child: Text('Изменить дату')),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const FittedBox(child: Text('Выбрать дату')),
                                  ),
                                ),
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      context.read<DateBloc>().add(const DateChange(null));
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                      primary: const Color.fromRGBO(243, 105, 105, 1.0),
                                    ),
                                    child: const Text('Отмена'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    textStyle: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  child: BlocBuilder<DateBloc, DateState>(
                    builder: (context, state) {
                      return state is DateNow ? Text(DateFormat.yMMMd('ru').format(state.dateNow!)) : const CircularProgressIndicator();
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _expense,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Введите сумму расхода';
                    return null;
                  },
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: "Введите сумму",
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    child: const FittedBox(child: Text("Добавить")),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Map<String, dynamic> expenses = {};
                        if (widget.category.expense != null) {
                          expenses = widget.category.expense!;
                        }
                        expenses[_expense.text] = dateNow;
                        BlocProvider.of<DataBloc>(context).add(UpdateCategory(
                          widget.category.id.toString(),
                          widget.category.category.toString(),
                          widget.category.color.toString(),
                          widget.category.owner.toString(),
                          expenses,
                        ));
                        Navigator.pop(context);
                      }
                    }),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      primary: const Color.fromRGBO(243, 105, 105, 1.0),
                    ),
                    child: const Text('Отмена'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
