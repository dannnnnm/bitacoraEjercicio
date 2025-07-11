import 'package:bitacora_ejercicios/exception/no_id_exception.dart';
import 'package:bitacora_ejercicios/model/location.dart';
import 'package:bitacora_ejercicios/repository/base_repository.dart';
import 'package:bitacora_ejercicios/utilTypes/option.dart';
import 'package:bitacora_ejercicios/utilTypes/result.dart';
import 'package:sqflite/sqflite.dart';

typedef LocationResultMap = Map<String, Object?>;

class LocationRepository extends BaseRepository<Location, Exception> {
  LocationRepository() : super("location");
  @override
  Future<Location> saveOne(
    Location location, {
    DatabaseExecutor? executor,
  }) async {
    executor ??= super.dbClient;
    int lastId = await executor.insert(tableName, location.toJson());
    Location savedEvidence = (await findOneByID(lastId,executor: executor)).unwrap();
    return savedEvidence;
  }

  @override
  Future<Option<Location>> findOneByID(
    int id, {
    DatabaseExecutor? executor,
  }) async {
    if (id == 0) {
      return None();
    }
    executor ??= super.dbClient;
    List<LocationResultMap> found = await executor.query(
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
  Location fromResult(LocationResultMap result) {
    int id = result["id"] as int;
    double latitude = result["latitude"] as double;
    double longitude = result["longitude"] as double;
    double altitude = result["altitude"] as double;
    int activityID = result["activity_id"] as int;
    return Location.load(
      id,
      activityID,
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
    );
  }

  @override
  Future<Result<Location, Exception>> update(
    Location location, {
    DatabaseExecutor? executor,
  }) async {
    if (location.id == 0) {
      return Err(NoIDException());
    }
    executor ??= super.dbClient;
    // ignore: unused_local_variable
    var result = await executor.update(
      tableName,
      location.toJson(),
      where: "id=?",
      whereArgs: [location.id],
    );
    var found = await findOneByID(location.id);
    return Ok(found.unwrap());
  }


  Future<Option<Location>> findByActivityID(
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

    LocationResultMap result = results.first;
    var location = fromResult(result);
    return Some(location);
  }
}


