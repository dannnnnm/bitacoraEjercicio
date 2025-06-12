import 'package:bitacora_ejercicios/model/activity.dart';
import 'package:bitacora_ejercicios/model/category.dart';
import 'package:bitacora_ejercicios/model/location.dart';
import 'package:bitacora_ejercicios/model/weather.dart';
import 'package:get/get.dart';


class MainScreenController extends GetxController{
  MainScreenController();
  RxList<Activity> activities=<Activity>[].obs;
  RxBool ready=false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadActivities();
    
  }

  void _loadActivities(){
    var mockLoadActivities=Future.delayed(Duration(seconds: 2), () async{
      activities.addAll([
        Activity("Correr", "Salir a correr al cerro Ñielol",Location(latitude: 0.0, longitude: 0.0), Category("a"),Weather.simple("RAINY","literally a blibical flood",32),10.0),
        Activity("Nadar", "Nadar en la piscina de la UFRO",Location(latitude: 0.0, longitude: 0.0), Category("a"),Weather.simple("RAINY","literally a blibical flood",32),10.0)
      ]);
      activities.refresh();
    });
    
    mockLoadActivities.then((value){
      ready.value=true;
    });
  }

  void modTest(){
    activities[0].name="No hacer nada";
    activities[0].category.name="Ninguna!";
    activities.refresh();
  }



}