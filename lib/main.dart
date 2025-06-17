import 'package:bitacora_ejercicios/layout/home_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bitácora Ejercicios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeLayout(), 
    );
  }
}
/*
class HomeLayoutController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> pages = [
    MainScreen(), // Tu pantalla actual
    Center(child: Text('Upcoming')),
    Center(child: Text('Completed')),
    Center(child: Text('Settings')),
  ];

  void onTabTapped(int index) {
    selectedIndex.value = index;
  }
}

class HomeLayout extends StatelessWidget {
  final controller = Get.put(HomeLayoutController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: controller.pages[controller.selectedIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.onTabTapped,
            selectedItemColor: const Color(0xFF0F1419),
            unselectedItemColor: const Color(0xFF59728C),
            backgroundColor: const Color(0xFFF9F9F9),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.inbox),
                label: 'Inbox',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Upcoming',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle),
                label: 'Completed',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ));
  }
}
*/