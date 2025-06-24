import 'package:bitacora_ejercicios/exception/unregistered_component_exception.dart';
import 'package:bitacora_ejercicios/utilTypes/json_map.dart';

class Location {
  Location.positional(this.latitude, this.longitude, this.altitude) : activityID = 0;
  Location.load(
    this.id,
    this.activityID, {
    required this.latitude,
    required this.longitude,
    required this.altitude,
  });
  Location({required this.latitude, required this.longitude, required this.altitude}) : activityID = 0;
  int id = 0;
  double latitude, longitude, altitude;
  int activityID;

  JSONMap toJson() {
    JSONMap json = {
      "latitude": latitude,
      "longitude": longitude,
      "altitude": altitude,
      "activity_id": activityID,
    };

    if (id != 0) {
      json["id"] = id;
    }
    if (activityID == 0) {
      throw UnregisteredComponentException(runtimeType.toString(), "Activity");
    }
    return json;
  }
}
