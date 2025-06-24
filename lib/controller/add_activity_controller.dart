import 'package:bitacora_ejercicios/controller/main_screen_controller.dart';
import 'package:bitacora_ejercicios/model/activity.dart';
import 'package:bitacora_ejercicios/model/category.dart';
import 'package:bitacora_ejercicios/model/location.dart';
import 'package:bitacora_ejercicios/model/weather.dart';
import 'package:bitacora_ejercicios/repository/activity_repository.dart';
import 'package:bitacora_ejercicios/repository/category_repository.dart';
import 'package:bitacora_ejercicios/screen/add_activity.dart';
import 'package:bitacora_ejercicios/screen/main_screen.dart';
import 'package:bitacora_ejercicios/widget/pretty_textfield_with_cb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddActivityController extends GetxController {
  AddActivityController() {
    init();
  }
  bool ready = false;
  RxString activityName = "".obs;
  RxString activityDescription = "".obs;
  double activityPoints = 0.0;
  RxList<Category> categories = <Category>[].obs;
  CategoryRepository categoryRepository = CategoryRepository();
  ActivityRepository activityRepository = ActivityRepository();
  RxBool inputValid = false.obs;

  RxString createdCategoryName = "".obs;

  Rx<Category?> selectedCategory = Rx(null);

  void init() {
    categoryRepository.findAll().then((results) {
      categories.addAll(results);
      categories.assignAll(categories.reversed.toList());
      selectedCategory.value = categories.firstOrNull;
      categories.refresh();
      ready = true;
    });
  }

  Future<void> addActivity() async {
    Activity newActivity = Activity(
      activityName.value,
      activityDescription.value,
      Location(latitude: 0.0, longitude: 0.0, altitude: 0.0),
      selectedCategory.value!,
      Weather.simple(
        "RAINY",
        "water droplets from the sky to the ground",
        20.0,
      ),
      activityPoints,
    );

    try {
      var savedActivity = await activityRepository.saveOne(newActivity);
      Get.delete<MainScreenController>();
      Get.offAll(() => MainScreen());
    } catch (e) {
      print("Saveing eer ${e.toString()}");
      Get.snackbar(
        "Error de guardado",
        "Error al guardar debido a ${e.toString()}",
      );
    }
  }

  void validateInput() {
    inputValid.value =
        activityName.trim().isNotEmpty &&
        activityDescription.trim().isNotEmpty &&
        selectedCategory.value != null &&
        activityPoints > 0.0;
  }

  Future<void> createCategoryDialog() async {
    Get.dialog(
      AlertDialog(
        title: Text("Crear categoria"),
        content: Column(
          children: [
            PrettyTextfieldWithCb(
              "Nombre Categoria",
              createdCategoryName,
              updateCB: validateInput,
              key: newCategoryNameKey,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              createdCategoryName.value = "";
              Get.back();
            },
          ),
          Obx(
            () => TextButton(
              onPressed:
                  createdCategoryName.trim().isEmpty
                      ? null
                      : () async {
                        var saved = await categoryRepository.saveOne(
                          Category(createdCategoryName.value),
                        );
                        categories.add(saved);
                        categories.assignAll(categories.reversed.toList());
                        selectedCategory.value = categories.first;
                        categories.refresh();
                        Get.back();
                      },
              key: saveNewCategoryButton,
              child: const Text("Ok"),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
