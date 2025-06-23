
import 'package:bitacora_ejercicios/main.dart';
import 'package:bitacora_ejercicios/main.dart' as app;
import 'package:bitacora_ejercicios/screen/add_activity.dart';
import 'package:bitacora_ejercicios/screen/main_screen.dart';
import 'package:convenient_test_dev/convenient_test_dev.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main(){
  convenientTestMain(BitacoraConvenientTestSlot(), (){
    tTestWidgets("Agregar actividad funciona", (t) async {
      var actName="test ${DateTime.now().millisecondsSinceEpoch}";

      t.get(find.byKey(Key(newActivityFAB))).tap();
      t.get(find.byKey(newActivityNameKey)).enterTextWithoutReplace(actName);
      t.get(find.byKey(newActivityDescriptionKey)).enterTextWithoutReplace("some description");
      t.get(find.byKey(newActivityScoreKey)).enterTextWithoutReplace("2.3");
      t.get(find.byKey(addActivityFABKey)).tap();
      find.text(actName);
    });
  });
}


class BitacoraConvenientTestSlot extends ConvenientTestSlot {
  @override
  Future<void> appMain(AppMainExecuteMode mode) async => app.main();

  @override
  BuildContext? getNavContext(ConvenientTest t) =>
      Get.context;
}

extension on ConvenientTest {
  Future<void> myCustomCommand() async {
    // Do anything you like... This is just a normal function
    debugPrint('Hello, world!');
  }
}