import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_accounting/business/bloc/auth/auth_bloc.dart';
import 'package:personal_accounting/business/bloc/color/color_bloc.dart';

import 'package:personal_accounting/business/bloc/data/data_bloc.dart';
import 'package:personal_accounting/business/functions/handles.dart';
import 'package:personal_accounting/business/models/user.dart';

Future showAddCategory({
  required BuildContext context,
}) async {
  return await showDialog(context: context, builder: (context) => const _AddCategoryDialog());
}

class _AddCategoryDialog extends StatefulWidget {
  const _AddCategoryDialog({Key? key}) : super(key: key);

  @override
  State<_AddCategoryDialog> createState() => __AddCategoryDialogState();
}

class __AddCategoryDialogState extends State<_AddCategoryDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _category = TextEditingController();
  String _nameColor = 'purple';

  List<String> listColors = ['red', 'orange', 'yellow', 'green', 'lightblue', 'blue', 'purple', 'black', 'pink', 'grey', 'brown', 'amber'];

  @override
  void didChangeDependencies() {
    context.read<ColorBloc>().add(const ColorChoise(null));
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
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: FittedBox(
                    child: Text(
                      'Добавить категорию',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  key: const Key('keyFieldNameCategory'),
                  controller: _category,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Введите название категории';
                    return null;
                  },
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Название",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<ColorBloc, ColorState>(
                  builder: (context, state) {
                    return state is ColorChoised
                        ? ElevatedButton(
                            key: const Key('keyChoiseColor'),
                            onPressed: () => showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Container(
                                      margin: const EdgeInsets.all(30),
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: FittedBox(
                                              child: Text(
                                                'Выберите цвет',
                                                style: Theme.of(context).textTheme.bodyText1,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Wrap(
                                                alignment: WrapAlignment.center,
                                                children: listColors.map((color) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Column(
                                                      children: [
                                                        RawMaterialButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              _nameColor = color;
                                                            });
                                                            context.read<ColorBloc>().add(ColorChoise(categoryColor(color)));
                                                            Navigator.pop(context);
                                                          },
                                                          fillColor: categoryColor(color),
                                                          padding: const EdgeInsets.all(30),
                                                          shape: const CircleBorder(),
                                                        ),
                                                        Text(
                                                          categoryNameColor(color),
                                                          style: TextStyle(color: categoryColor(color)),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            style: ElevatedButton.styleFrom(primary: state.color),
                            child: const FittedBox(child: Text('Выбрать цвет')),
                          )
                        : const CircularProgressIndicator();
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    key: const Key('keyAddCategory'),
                    child: const FittedBox(child: Text("Добавить")),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        UserApp user = BlocProvider.of<AuthBloc>(context, listen: false).state.props[0] as UserApp;
                        BlocProvider.of<DataBloc>(context).add(AddCategory(
                          _category.text,
                          _nameColor,
                          user.id,
                          const {},
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
