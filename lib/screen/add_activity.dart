import 'package:bitacora_ejercicios/controller/add_activity_controller.dart';
import 'package:bitacora_ejercicios/model/category.dart';
import 'package:bitacora_ejercicios/widget/pretty_textfield_with_cb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
const addActivityFABKey=Key("addActivityFAB");
const newActivityNameKey=Key("newActivityName");
const newActivityDescriptionKey=Key("newActivityDescription");
const newActivityCategoryKey=Key("newActivityCategory");
const newActivityScoreKey=Key("newActivityScore");
const newCategoryButtonKey=Key("newCategoryButton");
const newCategoryNameKey=Key("newCategoryName");
const saveNewCategoryButton=Key("saveNewCategoryButton");

//const saveNewActivityButtonKey=Key("saveNewActivityButton");
class Addactivity extends StatelessWidget{
  AddActivityController controller=AddActivityController();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(this.controller);

    return Scaffold(
      floatingActionButton: Obx(()=>FloatingActionButton(
        key: addActivityFABKey,
        onPressed: !controller.inputValid.value ? null : () {
          controller.addActivity();
        },
        child: const Icon(Icons.check),
      )),
      appBar: AppBar(
        title: const Text("Agregar actividad"),
        backgroundColor: Get.theme.colorScheme.inversePrimary,
      ),
      body: Obx(() => Column(
        children: [
          PrettyTextfieldWithCb(
              "Nombre de actividad",
              controller.activityName,
              updateCB: controller.validateInput,
              key: newActivityNameKey,
            ),

            PrettyTextfieldWithCb(
              "Descripcion de actividad",
              controller.activityDescription,
              updateCB: controller.validateInput,
              key: newActivityDescriptionKey,
            ),
          
          Row(
              children: [
                DropdownMenu(
                  dropdownMenuEntries: controller.categories.fold(
                    <DropdownMenuEntry<Category>>[],
                    (collector, category) {
                      DropdownMenuEntry<Category> entry = DropdownMenuEntry(
                        value: category,
                        label: category.name,
                      );
                      collector.add(entry);
                      return collector;
                    },
                  ),
                  requestFocusOnTap: true,
                  initialSelection: controller.categories.firstOrNull,
                  onSelected: (value) {
                    controller.selectedCategory.value = value;
                    controller.validateInput();
                  },
                  key: newActivityCategoryKey,
                ),
                IconButton(
                  key: newCategoryButtonKey,
                  icon: Icon(Icons.add),
                  onPressed: () {
                    //idk
                    controller.createCategoryDialog();
                  },
                ),

              ],
            ),
            PrettyTextfieldWithCb.withCustomCB(
              "Puntos",
              (txt) {
                try{
                  controller.activityPoints=double.parse(txt);
                  controller.validateInput();
                }catch (e){
                  print(e.toString());
                }
                
                
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              key: newActivityScoreKey,
            )


        ],
      )),
    );
  }
}