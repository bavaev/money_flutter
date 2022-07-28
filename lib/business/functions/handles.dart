import 'package:flutter/material.dart';
import 'package:personal_accounting/business/models/category.dart';

Color categoryColor(String color) {
  if (color == 'red') {
    return Colors.red;
  } else if (color == 'orange') {
    return Colors.orange;
  } else if (color == 'yellow') {
    return Colors.yellow;
  } else if (color == 'green') {
    return Colors.green;
  } else if (color == 'lightblue') {
    return Colors.lightBlue;
  } else if (color == 'blue') {
    return Colors.blue;
  } else if (color == 'black') {
    return Colors.black;
  } else if (color == 'pink') {
    return Colors.pink;
  } else if (color == 'grey') {
    return Colors.grey;
  } else if (color == 'brown') {
    return Colors.brown;
  } else if (color == 'amber') {
    return Colors.amber;
  }
  return const Color.fromRGBO(144, 83, 235, 1.0);
}

String categoryNameColor(String color) {
  if (color == 'red') {
    return 'Красный';
  } else if (color == 'orange') {
    return 'Оранжевый';
  } else if (color == 'yellow') {
    return 'Жёлтый';
  } else if (color == 'green') {
    return 'Зелёный';
  } else if (color == 'lightblue') {
    return 'Голубой';
  } else if (color == 'blue') {
    return 'Синий';
  } else if (color == 'black') {
    return 'Чёрный';
  } else if (color == 'pink') {
    return 'Розовый';
  } else if (color == 'grey') {
    return 'Серый';
  } else if (color == 'brown') {
    return 'Коричневый';
  } else if (color == 'amber') {
    return 'Янтарный';
  }
  return 'Фиолетовый';
}

String authMessages(String error) {
  if (error == 'email not found') {
    return 'E-mail не зарегистрирован!';
  } else if (error == 'wrong password') {
    return 'Неверный пароль!';
  } else if (error == 'The password provided is too weak.') {
    return 'Слишком слабый пароль!';
  } else if (error == 'The account already exists for that email.') {
    return 'Этот E-mail уже есть существует!';
  }
  return 'Ошибка';
}

List<Category> dateSeparate(List<Category> categories, DateTime? date) {
  List<Category> list = [];
  for (Category category in categories) {
    if (category.expense != null) {
      category.expense!.forEach((key, value) {
        if (DateTime.fromMillisecondsSinceEpoch(value.seconds * 1000).year == date!.year) {
          if (DateTime.fromMillisecondsSinceEpoch(value.seconds * 1000).month == date.month) {
            list.add(category);
          }
        }
      });
    }
  }
  return list;
}

double expenses(List<String> expenses) {
  double sum = 0.0;
  for (String expense in expenses) {
    sum += double.tryParse(expense) as double;
  }
  return sum;
}

Category list(List<Category> categories, String id) {
  for (Category category in categories) {
    if (category.id == id) {
      return category;
    }
  }
  return categories[0];
}
