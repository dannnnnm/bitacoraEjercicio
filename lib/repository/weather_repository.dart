import 'package:bitacora_ejercicios/exception/no_id_exception.dart';
import 'package:bitacora_ejercicios/model/weather.dart';
import 'package:bitacora_ejercicios/repository/base_repository.dart';
import 'package:bitacora_ejercicios/utilTypes/option.dart';
import 'package:bitacora_ejercicios/utilTypes/result.dart';
import 'package:sqflite_common/sqlite_api.dart';

typedef WeatherResultMap = Map<String, Object?>;

class WeatherRepository extends BaseRepository<Weather, Exception> {
  WeatherRepository() : super("weather");
  @override
  Future<Option<Weather>> findOneByID(
    int id, {
    DatabaseExecutor? executor,
  }) async {
    if (id == 0) {
      return None();
    }
    executor ??= super.dbClient;
    List<WeatherResultMap> found = await executor.query(
      tableName,
      where: "id=?",
      whereArgs: [id],
    );
    if (found.isEmpty) {
      return None();
    }
    var category = fromResult(found.first);
    return Some(category);
  }

  @override
  Weather fromResult(Map<String, Object?> result) {
    int id = result["id"] as int;
    double currentTemperature = result["current_temperature"] as double;
    double maxTemperature = result["max_temperature"] as double;
    double minTemperature = result["min_temperature"] as double;
    int windSpeed = result["wind_speed"] as int;
    String weatherStatus = result["status"] as String;
    String weatherDescription = result["description"] as String;
    int activityID = result["activity_id"] as int;

    return Weather.load(
      id,
      weatherStatus,
      weatherDescription,
      currentTemperature,
      activityID,
      maxTemperatureCelsius: maxTemperature,
      minTemperatureCelsius: minTemperature,
      windSpeedKmh: windSpeed,
    );
  }

  @override
  Future<Weather> saveOne(Weather weather, {DatabaseExecutor? executor}) async {
    executor ??= super.dbClient;
    int lastId = await executor.insert(tableName, weather.toDBJson());
    Weather savedWeather = (await findOneByID(lastId,executor:executor)).unwrap();
    return savedWeather;
  }

  @override
  Future<Result<Weather, Exception>> update(
    Weather weather, {
    DatabaseExecutor? executor,
  }) async {
    if (weather.id == 0) {
      return Err(NoIDException());
    }
    executor ??= super.dbClient;
    // ignore: unused_local_variable
    var result = await executor.update(
      tableName,
      weather.toDBJson(),
      where: "id=?",
      whereArgs: [weather.id],
    );
    var found = await findOneByID(weather.id);
    return Ok(found.unwrap());
  }


  Future<Option<Weather>> findByActivityID(
    int activityID, {
    DatabaseExecutor? executor,
  }) async {
    executor ??= super.dbClient;
    var results = await executor.query(
      tableName,
      where: "activity_id=?",
      whereArgs: [activityID],
    );
    if (results.isEmpty) {
      return None();
    }

    WeatherResultMap result = results.first;
    var location = fromResult(result);
    return Some(location);
  }
}
