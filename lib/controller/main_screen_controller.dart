import 'package:bitacora_ejercicios/model/activity.dart';
import 'package:bitacora_ejercicios/model/category.dart';
import 'package:bitacora_ejercicios/model/location.dart';
import 'package:bitacora_ejercicios/model/weather.dart';
import 'package:bitacora_ejercicios/repository/activity_repository.dart';
import 'package:bitacora_ejercicios/screen/add_activity.dart';
import 'package:get/get.dart';

class MainScreenController extends GetxController {
  MainScreenController() {
    //_loadActivities();
  }
  RxList<Activity> activities = <Activity>[].obs;
  RxBool ready = false.obs;

  ActivityRepository activityRepository = ActivityRepository();
  @override
  void onInit() {
    super.onInit();
    _loadActivities();
  }

  void _loadActivities() {
    // var mockLoadActivities = Future.delayed(
    //   Duration(milliseconds: 400),
    //   () async {
    //     activities.addAll([
    //       Activity(
    //         "Correr",
    //         "Salir a correr al cerro Ñielol",
    //         Location(latitude: 0.0, longitude: 0.0, altitude: 0.0),
    //         Category("a"),
    //         Weather.simple("RAINY", "literally a blibical flood", 32),
    //         10.0,
    //       ),
    //       Activity(
    //         "Nadar",
    //         "Nadar en la piscina de la UFRO",
    //         Location(latitude: 0.0, longitude: 0.0, altitude: 0.0),
    //         Category("a"),
    //         Weather.simple("RAINY", "literally a blibical flood", 32),
    //         10.0,
    //       ),
    //     ]);
    //     activities.refresh();
    //   },
    // );

    var realLoadActivities = activityRepository.findAll();
    realLoadActivities.then((rActivities) {
      print("found ${rActivities.length} saved activities");
      this.activities.addAll(rActivities);
      this.activities.assignAll(this.activities.reversed.toList());
      this.activities.refresh();
      ready.value = true;
      print("coso ${activities.map((act) => act.name).toList()}");
    });
    //mockLoadActivities.then((value) {});
  }

  void modTest() {
    activities[0].name = "No hacer nada";
    activities[0].category.name = "Ninguna!";
    activities.refresh();
  }

  void toAddActivity() async {
    await Get.to(() => Addactivity());
    var withNewActivities = await activityRepository.findAll();
    activities.assignAll(withNewActivities.reversed.toList());
    activities.refresh();
  }
}
