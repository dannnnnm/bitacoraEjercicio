import 'package:bitacora_ejercicios/main.dart';
import 'package:bitacora_ejercicios/main.dart' as app;
import 'package:bitacora_ejercicios/model/category.dart';
import 'package:bitacora_ejercicios/repository/category_repository.dart';
import 'package:bitacora_ejercicios/screen/activity_detail.dart';
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

      //ir a la pantalla de agregar actividad
      await t.get(find.byKey(newActivityFABKey)).tap();
      await t.tester.pumpAndSettle(Duration(seconds: 2));
      await t.tester.ensureVisible(find.byKey(newActivityNameKey));

      //rellenar datos
      await t
          .get(find.byKey(newActivityNameKey))
          .enterTextWithoutReplace(actName);
      await t
          .get(find.byKey(newActivityDescriptionKey))
          .enterTextWithoutReplace("some description");
      await t
          .get(find.byKey(newActivityScoreKey))
          .enterTextWithoutReplace("2.3");

      //apretar boton para guardar
      await t.get(find.byKey(addActivityFABKey)).tap();
      await t.tester.pumpAndSettle(Duration(seconds: 2));
      await t.tester.ensureVisible(find.byKey(Key("${actList}0")));

      //revisar que exista la entrada en la lista principal
      expect(find.text(actName), findsOneWidget);
    });

    tTestWidgets("Agregar actividad funciona creando nueva categoria", (
      t,
    ) async {
      await t.tester.pumpAndSettle(Duration(seconds: 2));

      //generar nombres unicos
      var catName = "cat ${DateTime.now().millisecondsSinceEpoch}";
      var actName = "test ${DateTime.now().millisecondsSinceEpoch}";

      //ir a crear actividad
      await t.tester.ensureVisible(find.byKey(newActivityFABKey));
      await t.get(find.byKey(newActivityFABKey)).tap();
      await t.tester.pumpAndSettle(Duration(seconds: 2));
      await t.tester.ensureVisible(find.byKey(newActivityNameKey));
      //rellenar datos
      await t
          .get(find.byKey(newActivityNameKey))
          .enterTextWithoutReplace(actName);
      await t
          .get(find.byKey(newActivityDescriptionKey))
          .enterTextWithoutReplace("some description");

      //abrir panel de crear nueva categoria, rellenar datos y guardar
      await t.get(find.byKey(newCategoryButtonKey)).tap();
      await t
          .get(find.byKey(newCategoryNameKey))
          .enterTextWithoutReplace(catName);

      await t.get(find.byKey(saveNewCategoryButton)).tap();

      await t
          .get(find.byKey(newActivityScoreKey))
          .enterTextWithoutReplace("2.3");
      //guardar nueva actividad
      await t.get(find.byKey(addActivityFABKey)).tap();
      await t.tester.pumpAndSettle(Duration(seconds: 2));
      await t.tester.ensureVisible(find.byKey(Key("${actList}0")));

      //entrar al detalle de la actividad
      await find.text(actName).tap();

      await t.tester.pumpAndSettle(Duration(seconds: 2));
      //await t.tester.ensureVisible(find.byKey(newActivityNameKey));

      //verificar categoria
      expect(find.text(catName), findsOneWidget);
    });

    tTestWidgets("Agregar actividad funciona creando nueva categoria", (
      t,
    ) async {
      await t.tester.pumpAndSettle(Duration(seconds: 2));

      //generar nombres unicos

      //ir a crear actividad
      var foundEntry=await find.textContaining("test").first;
      await foundEntry.tap();

      t.tester.pumpAndSettle(Duration(seconds: 2));

      var finder=find.byKey(markCompletedKey);
      var button=t.tester.widget<ElevatedButton>(finder);
      var style=button.style!;
      var originalIsCompleted=style.backgroundColor!.resolve(<WidgetState>{})==Colors.green[600];
      await finder.tap();
      find.byIcon(Icons.arrow_back).tap();

      t.tester.pumpAndSettle(Duration(seconds: 2));

      await foundEntry.tap();

      t.tester.pumpAndSettle(Duration(seconds: 2));

      var nbutton=t.tester.widget<ElevatedButton>(finder);
      var nstyle=nbutton.style!;
      var persistedIsCompleted=nstyle.backgroundColor!.resolve(<WidgetState>{})==Colors.green[600];
      expect(persistedIsCompleted, isNot(originalIsCompleted));
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
