
import 'package:bitacora_ejercicios/exception/unregistered_component_exception.dart';
import 'package:bitacora_ejercicios/utilTypes/json_map.dart';

class Location {
  Location.positional(this.latitude,this.longitude);
  Location.load(this.id,{required this.latitude,required this.longitude});
  Location({required this.latitude,required this.longitude});
  int id=0;
  double latitude,longitude;
  int activityID=0;

  JSONMap toJson(){
    JSONMap json={
      "latitude":latitude,
      "longitude":longitude,
      "activity_id":activityID,
    };

    if (id!=0){
      json["id"]=id;
    }
    if (activityID==0){
      throw UnregisteredComponentException(runtimeType.toString(), "Activity");
    }
    return json;
  }
}