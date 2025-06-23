import 'package:bitacora_ejercicios/main.dart';
import 'package:bitacora_ejercicios/main.dart' as app;
import 'package:bitacora_ejercicios/model/category.dart';
import 'package:bitacora_ejercicios/repository/category_repository.dart';
import 'package:bitacora_ejercicios/screen/add_activity.dart';
import 'package:bitacora_ejercicios/screen/main_screen.dart';
import 'package:convenient_test_dev/convenient_test_dev.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  convenientTestMain(BitacoraConvenientTestSlot(), () {
    tTestWidgets("Agregar actividad funciona", (t) async {
      await CategoryRepository().saveOne(Category("testCat"));
      await t.tester.pumpAndSettle(Duration(seconds: 2));
      var actName = "test ${DateTime.now().millisecondsSinceEpoch}";
      await t.tester.ensureVisible(find.byKey(newActivityFABKey));
      await t.get(find.byKey(newActivityFABKey)).tap();
      await t.tester.pumpAndSettle(Duration(seconds: 2));
      await t.tester.ensureVisible(find.byKey(newActivityNameKey));
      await t
          .get(find.byKey(newActivityNameKey))
          .enterTextWithoutReplace(actName);
      await t
          .get(find.byKey(newActivityDescriptionKey))
          .enterTextWithoutReplace("some description");
      await t
          .get(find.byKey(newActivityScoreKey))
          .enterTextWithoutReplace("2.3");

      await t.get(find.byKey(addActivityFABKey)).tap();
      await t.tester.pumpAndSettle(Duration(seconds: 2));
      await t.tester.ensureVisible(find.byKey(Key("${actList}0")));
      expect(find.text(actName), findsOneWidget);
    });

    tTestWidgets("Agregar actividad funciona creando nueva categoria", (
      t,
    ) async {
      await t.tester.pumpAndSettle(Duration(seconds: 2));
      var catName = "cat ${DateTime.now().millisecondsSinceEpoch}";
      var actName = "test ${DateTime.now().millisecondsSinceEpoch}";
      await t.tester.ensureVisible(find.byKey(newActivityFABKey));
      await t.get(find.byKey(newActivityFABKey)).tap();
      await t.tester.pumpAndSettle(Duration(seconds: 2));
      await t.tester.ensureVisible(find.byKey(newActivityNameKey));
      await t
          .get(find.byKey(newActivityNameKey))
          .enterTextWithoutReplace(actName);
      await t
          .get(find.byKey(newActivityDescriptionKey))
          .enterTextWithoutReplace("some description");

      await t.get(find.byKey(newCategoryButtonKey)).tap();
      await t
          .get(find.byKey(newCategoryNameKey))
          .enterTextWithoutReplace(catName);

      await t.get(find.byKey(saveNewCategoryButton)).tap();

      await t
          .get(find.byKey(newActivityScoreKey))
          .enterTextWithoutReplace("2.3");

      await t.get(find.byKey(addActivityFABKey)).tap();
      await t.tester.pumpAndSettle(Duration(seconds: 2));
      await t.tester.ensureVisible(find.byKey(Key("${actList}0")));
      await find.text(actName).tap();
      await t.tester.pumpAndSettle(Duration(seconds: 2));
      //await t.tester.ensureVisible(find.byKey(newActivityNameKey));

      expect(find.text(catName), findsOneWidget);
    });
  });
}

class BitacoraConvenientTestSlot extends ConvenientTestSlot {
  @override
  Future<void> appMain(AppMainExecuteMode mode) async => app.main();

  @override
  BuildContext? getNavContext(ConvenientTest t) => Get.context;
}

extension on ConvenientTest {
  Future<void> myCustomCommand() async {
    // Do anything you like... This is just a normal function
    debugPrint('Hello, world!');
  }
}
