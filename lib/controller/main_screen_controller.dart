import 'package:bitacora_ejercicios/model/activity.dart';
import 'package:bitacora_ejercicios/model/category.dart';
import 'package:bitacora_ejercicios/model/location.dart';
import 'package:bitacora_ejercicios/model/weather.dart';
import 'package:bitacora_ejercicios/repository/activity_repository.dart';
import 'package:bitacora_ejercicios/screen/add_activity.dart';
import 'package:get/get.dart';


class MainScreenController extends GetxController{
  MainScreenController(){
    _loadActivities();
  }
  RxList<Activity> activities=<Activity>[].obs;
  RxBool ready=false.obs;

  ActivityRepository activityRepository=ActivityRepository();
  // @override
  // void onInit() {
  //   super.onInit();
  //   _loadActivities();
    
  // }

  void _loadActivities(){
    var mockLoadActivities=Future.delayed(Duration(seconds: 2), () async{
      activities.addAll([
        Activity("Correr", "Salir a correr al cerro Ñielol",Location(latitude: 0.0, longitude: 0.0), Category("a"),Weather.simple("RAINY","literally a blibical flood",32),10.0),
        Activity("Nadar", "Nadar en la piscina de la UFRO",Location(latitude: 0.0, longitude: 0.0), Category("a"),Weather.simple("RAINY","literally a blibical flood",32),10.0)
      ]);
      activities.refresh();
    });

    var realLoadActivities=activityRepository.findAll();
    
    mockLoadActivities.then((value){
      realLoadActivities.then((activities){
        print("found ${activities.length} saved activities");
        this.activities.addAll(activities);
        this.activities.assignAll(this.activities.reversed.toList());
        
        ready.value=true;
        this.activities.refresh();
      });
    });

    
  }

  void modTest(){
    activities[0].name="No hacer nada";
    activities[0].category.name="Ninguna!";
    activities.refresh();
  }


  void toAddActivity() async {
    await Get.to(()=>Addactivity());
    var withNewActivities=await activityRepository.findAll();
    activities.assignAll(withNewActivities.reversed.toList());
    activities.refresh();
    
  }



}