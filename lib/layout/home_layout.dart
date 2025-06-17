import 'package:bitacora_ejercicios/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeLayoutController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> pages = [
    MainScreen(), // Esta es tu pantalla principal actual
    Center(child: Text('Upcoming')),
    Center(child: Text('Completed')),
    Center(child: Text('Settings')),
  ];

  void onTabTapped(int index) {
    selectedIndex.value = index;
  }
}



// ignore: use_key_in_widget_constructors
class HomeLayout extends StatelessWidget {
  final controller = Get.put(HomeLayoutController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: controller.pages[controller.selectedIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.onTabTapped,
            selectedItemColor: Color(0xFF0F1419),
            unselectedItemColor: Color(0xFF59728C),
            backgroundColor: Color(0xFFF9F9F9),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.inbox), label: 'Inbox'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today), label: 'Upcoming'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle), label: 'Completed'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        ));
  }
}
