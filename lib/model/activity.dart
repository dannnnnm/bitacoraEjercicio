import 'package:bitacora_ejercicios/exception/unregistered_component_exception.dart';
import 'package:bitacora_ejercicios/model/category.dart';
import 'package:bitacora_ejercicios/model/evidence_image.dart';
import 'package:bitacora_ejercicios/model/location.dart';
import 'package:bitacora_ejercicios/model/weather.dart';
import 'package:bitacora_ejercicios/utilTypes/json_map.dart';

class Activity {
  Activity(
    this.name,
    this.description,
    this.location,
    this.category,
    this.weather,
    this.experience,
  ) : date = DateTime.now(),
      completed = false;

  //Activity.loadWithoutImage(this.id, this.name,this.description,this.location,this.category,this.date, this.experience);
  Activity.load(
    this.id,
    this.name,
    this.description,
    this.location,
    this.category,
    this.weather,
    this.date,
    this.experience,
    this.evidence,
    int completedNum,
  ) : completed = completedNum > 0;
  int id = 0;
  double experience;
  String name, description;
  Location location;
  DateTime date;
  DateTime? deletedAt;
  Category category;
  EvidenceImage? evidence;
  bool completed;
  Weather weather;

  JSONMap toJSon() {
    JSONMap json = {
      "name": name,
      "description": description,
      "experience": experience,
      "date": date.millisecondsSinceEpoch,
      "deleted_at": deletedAt?.millisecondsSinceEpoch,
      "completed": completed ? 1 : 0,
    };
    if (id != 0) {
      json["id"] = id;
    }
    if (category.id != 0) {
      json["category_id"] = category.id;
    }
    if (category.id == 0) {
      throw UnregisteredComponentException("Activity", "Category");
    }

    // if (location.id!=0){
    //   json["location_id"]=location.id;
    // }

    // if (evidence!=null && evidence!.id!=0){
    //   json["evidence_id"]=evidence!.id;

    // }

    return json;
  }
}
