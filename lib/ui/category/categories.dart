import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:personal_accounting/business/models/category.dart';
import 'package:personal_accounting/business/bloc/data/data_bloc.dart';
import 'package:personal_accounting/business/functions/handles.dart';
import 'package:personal_accounting/business/bloc/color/color_bloc.dart';
import 'package:personal_accounting/ui/components/add_category.dart';
import 'package:personal_accounting/ui/widgets/bottom_bar.dart';
import 'package:personal_accounting/business/functions/string_extension.dart';
import 'package:personal_accounting/ui/category/list_categories.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  DateTime dateNow = DateTime.now();
  DateTime? selectedDate;

  @override
  void didChangeDependencies() {
    context.read<ColorBloc>().add(const ColorChoise(null));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ru');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => showMonthPicker(
                      context: context,
                      initialDate: selectedDate ?? dateNow,
                      locale: const Locale('ru'),
                    ).then((DateTime? date) {
                      if (date != null) {
                        setState(() => selectedDate = date);
                      }
                    }),
                    child: Text(
                      '${DateFormat.MMMM('ru').format(selectedDate ?? dateNow).capitalize()} ${DateFormat.y('ru').format(selectedDate ?? dateNow).capitalize()}',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              key: const Key('keyNewCategory'),
              onPressed: () {
                showAddCategory(
                  context: context,
                );
              },
              icon: const Icon(
                Icons.add,
                size: 40,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                color: const Color.fromRGBO(208, 208, 208, 1.0),
                child: BlocBuilder<DataBloc, DataState>(
                  builder: (context, state) {
                    if (state is Data) {
                      List<Category> categories = state.categories;
                      bool _isExpanses = false;
                      for (Category category in categories) {
                        category.expense != null ? _isExpanses = true : null;
                      }
                      if (selectedDate != null) {
                        categories = dateSeparate(categories, selectedDate);
                      }
                      return categories.isNotEmpty && _isExpanses
                          ? SfCircularChart(
                              series: <CircularSeries<Category, String>>[
                                DoughnutSeries<Category, String>(
                                  dataSource: state.categories,
                                  innerRadius: '35%',
                                  radius: '90%',
                                  dataLabelMapper: (Category category, _) => category.category,
                                  pointColorMapper: (Category category, _) => categoryColor(category.color.toString()),
                                  xValueMapper: (Category category, _) => category.category,
                                  yValueMapper: (Category category, _) => category.expense != null ? expenses(category.expense!.keys.toList()) : 0.0,
                                  dataLabelSettings: const DataLabelSettings(
                                    showZeroValue: false,
                                    isVisible: true,
                                    textStyle: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Center(
                              child: Text(
                                  'За ${selectedDate != null ? DateFormat.MMMM('ru').format(selectedDate!).capitalize() : DateFormat.MMMM('ru').format(dateNow).capitalize()} нет расходов'),
                            );
                    }
                    return const Center(child: Text('Расходов нет'));
                  },
                ),
              ),
            ),
            const Flexible(
              flex: 2,
              child: ListCategories(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
