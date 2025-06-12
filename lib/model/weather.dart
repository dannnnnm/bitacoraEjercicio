import 'package:bitacora_ejercicios/exception/unregistered_component_exception.dart';
import 'package:bitacora_ejercicios/utilTypes/json_map.dart';

class Weather {
  Weather(
    this.weatherStatus,
    this.weatherDescription,
    this.currentTemperatureCelsius,
    this.minTemperatureCelsius,
    this.maxTemperatureCelsius,
    this.windSpeedKmh,
  ) : activityID = 0;
  Weather.simple(
    this.weatherStatus,
    this.weatherDescription,
    this.currentTemperatureCelsius,
  ) : activityID = 0;
  Weather.load(
    this.id,
    this.weatherStatus,
    this.weatherDescription,
    this.currentTemperatureCelsius,
    this.activityID, {
    this.minTemperatureCelsius = 0,
    this.maxTemperatureCelsius = 0,
    this.windSpeedKmh = 0,
  });
  int id = 0;
  String weatherStatus, weatherDescription;
  double maxTemperatureCelsius = 0;

  double minTemperatureCelsius = 0;
  double currentTemperatureCelsius;
  int windSpeedKmh = 0;
  int activityID;

  JSONMap toDBJson() {
    JSONMap json = {
      "status": weatherStatus,
      "description": weatherDescription,
      "current_temperature": currentTemperatureCelsius,
      "max_temperature": maxTemperatureCelsius,
      "min_temperature": minTemperatureCelsius,
      "wind_speed": windSpeedKmh,
      "activity_id": activityID,
    };
    if (id != 0) {
      json["id"] = id;
    }
    if (activityID == 0) {
      throw UnregisteredComponentException(runtimeType.toString(), "activity");
    }
    return json;
  }
}
