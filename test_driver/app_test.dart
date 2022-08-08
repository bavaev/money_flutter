import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Add category test', () {
    FlutterDriver? driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() {
      if (driver != null) {
        driver!.close();
      }
    });

    final filledFinderAddButton = find.byValueKey('keyNewCategory');

    test('Tap on Add button', () async {
      await driver!.tap(filledFinderAddButton);
    });

    final filledFinderCategory = find.byValueKey('keyFieldNameCategory');
    final filledFinderAddCategory = find.byValueKey('keyAddCategory');

    test('Test Field Name Category', () async {
      await driver!.tap(filledFinderCategory);
      await driver!.waitFor(find.text(''));
      await driver!.enterText('newCategory');
      await driver!.waitFor(find.text('newCategory'));
    });

    test('Test Add Category', () async {
      await driver!.tap(filledFinderAddCategory);
    });
  });
}
