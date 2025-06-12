import 'package:bitacora_ejercicios/controller/main_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class MainScreen extends StatelessWidget{
  MainScreen();
  MainScreenController controller=MainScreenController();
  @override
  Widget build(BuildContext context) {
    var controller=Get.put(this.controller);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        controller.modTest();
      },child: Icon(Icons.add),),
      body: Obx(()=>ListView(
        children: controller.activities.map((activity)=>ListTile(leading: Icon(Icons.gas_meter),title: Text(activity.name),subtitle: Text(activity.description),trailing: Text(activity.category.name),)).toList())),
      appBar: AppBar(
        title: Text("Ejercicios"),
        backgroundColor: Get.theme.colorScheme.inversePrimary,
      ),
    );
  }
  
}