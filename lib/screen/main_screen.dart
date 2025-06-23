import 'package:bitacora_ejercicios/components/activity_card.dart';
import 'package:bitacora_ejercicios/controller/main_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String newActivityFAB="newActivityFAB";
// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final MainScreenController controller = MainScreenController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(this.controller);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: const Key(newActivityFAB),
        onPressed: () {
          controller.toAddActivity();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Ejercicios"),
        backgroundColor: Get.theme.colorScheme.inversePrimary,
      ),
      body: Obx(() => ListView(
            padding: const EdgeInsets.all(16),
            children: controller.activities
                .map((activity) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ActivityCard(activity: activity),
                    ))
                .toList(),
          )),
    );
  }
}
