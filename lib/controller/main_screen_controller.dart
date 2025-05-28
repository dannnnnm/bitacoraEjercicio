import 'package:bitacora_ejercicios/model/activity.dart';
import 'package:bitacora_ejercicios/model/category.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

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
        Activity("Correr", "Salir a correr al cerro Ñielol", Category("a")),
        Activity("Nadar", "Nadar en la piscina de la UFRO", Category("a"))
      ]);
      activities.refresh();
    });
    
    mockLoadActivities.then((value){
      ready.value=true;
    });
  }

}