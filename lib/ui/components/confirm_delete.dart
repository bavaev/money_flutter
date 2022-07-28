import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_accounting/business/bloc/data/data_bloc.dart';
import 'package:personal_accounting/business/models/category.dart';

Future showConfirmDeleteDialog({
  required BuildContext context,
  required String type,
  String? categoryId,
  String? nameCategory,
  Category? category,
}) async {
  return await showDialog(
      context: context,
      builder: (context) => _ConfirmDeleteDialog(
            type: type,
            categoryId: categoryId,
            nameCategory: nameCategory,
            category: category,
          ));
}

class _ConfirmDeleteDialog extends StatefulWidget {
  const _ConfirmDeleteDialog({Key? key, this.type, this.categoryId, this.nameCategory, this.category}) : super(key: key);

  final String? type;
  final String? categoryId;
  final String? nameCategory;
  final Category? category;

  @override
  State<_ConfirmDeleteDialog> createState() => _ConfirmDeleteDialogState();
}

class _ConfirmDeleteDialogState extends State<_ConfirmDeleteDialog> {
  String getTextConfirmation() {
    if (widget.type == 'category') {
      return 'Удалить категорию ${widget.nameCategory}?';
    } else if (widget.type == 'expense') {
      return 'Удалить данные о расходе?';
    } else {
      return 'Вы действительно хотите удалить все данные?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: Text(
              getTextConfirmation(),
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
          ),
          ElevatedButton(
            onPressed: () {
              if (widget.type == 'category') {
                BlocProvider.of<DataBloc>(context).add(RemoveCategory(widget.categoryId.toString()));
              }
              if (widget.type == 'expense') {
                BlocProvider.of<DataBloc>(context).add(UpdateCategory(
                  widget.category!.id.toString(),
                  widget.category!.category.toString(),
                  widget.category!.color.toString(),
                  widget.category!.owner.toString(),
                  widget.category!.expense as Map<String, dynamic>,
                ));
              }
              if (widget.type == 'deleteAllData') {
                context.read<DataBloc>().add(RemoveAllData());
              }
              Navigator.pop(context, null);
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(const Size(325, 45)),
              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
            ),
            child: const Text('Удалить'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            style: TextButton.styleFrom(
              primary: const Color.fromRGBO(243, 105, 105, 1.0),
            ),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }
}
