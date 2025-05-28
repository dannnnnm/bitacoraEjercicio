import 'package:bitacora_ejercicios/model/category.dart';

class Activity {
  Activity(this.name,this.description,this.category):date=DateTime.now();

  String name, description;
  DateTime date;
  Category category;
}