import 'package:bitacora_ejercicios/exception/unregistered_component_exception.dart';
import 'package:bitacora_ejercicios/utilTypes/json_map.dart';

class Weather {
  Weather(this.weatherStatus,this.weatherDescription,this.currentTemperatureCelsius,this.minTemperatureCelsius,this.maxTemperatureCelsius,this.windSpeedKmh);
  Weather.simple(this.weatherStatus,this.weatherDescription,this.currentTemperatureCelsius);
  Weather.load(
    this.id,
    this.weatherStatus,
    this.weatherDescription,
    this.currentTemperatureCelsius, {
    this.minTemperatureCelsius = 0,
    this.maxTemperatureCelsius = 0,
    this.windSpeedKmh = 0,
  });
  int id=0;
  String weatherStatus,weatherDescription;
  int maxTemperatureCelsius=0;
  
  int minTemperatureCelsius=0;
  int currentTemperatureCelsius;
  int windSpeedKmh=0;
  int activityID=0;

  JSONMap toDBJson(){
    JSONMap json={
      "weather_status":weatherStatus,
      "weather_description":weatherDescription,
      "current_temperature":currentTemperatureCelsius,
      "max_temperature":maxTemperatureCelsius,
      "min_temperature":minTemperatureCelsius,
      "wind_speed":windSpeedKmh,
      "activity_id":activityID
    };
    if (id!=0){
      json["id"]=id;
    }
    if (activityID==0){
      throw UnregisteredComponentException(runtimeType.toString(), "activity");
    }
    return json;
  }

}