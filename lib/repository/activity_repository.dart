import 'package:bitacora_ejercicios/exception/no_id_exception.dart';
import 'package:bitacora_ejercicios/exception/unregistered_component_exception.dart';
import 'package:bitacora_ejercicios/exception/unsupported_param_exception.dart';
import 'package:bitacora_ejercicios/model/activity.dart';
import 'package:bitacora_ejercicios/model/category.dart';
import 'package:bitacora_ejercicios/model/evidence_image.dart';
import 'package:bitacora_ejercicios/model/location.dart';
import 'package:bitacora_ejercicios/model/weather.dart';
import 'package:bitacora_ejercicios/repository/base_repository.dart';
import 'package:bitacora_ejercicios/repository/category_repository.dart';
import 'package:bitacora_ejercicios/repository/evidence_repository.dart';
import 'package:bitacora_ejercicios/repository/location_repository.dart';
import 'package:bitacora_ejercicios/repository/weather_repository.dart';
import 'package:bitacora_ejercicios/utilTypes/option.dart';
import 'package:bitacora_ejercicios/utilTypes/result.dart';
import 'package:sqflite/sqflite.dart';

typedef ActivityResultMap = Map<String, Object?>;

class ActivityRepository extends BaseRepository<Activity, Exception> {
  ActivityRepository() : super("activity");
  CategoryRepository categoryRepository = CategoryRepository();
  EvidenceRepository evidenceRepository = EvidenceRepository();
  LocationRepository locationRepository = LocationRepository();
  WeatherRepository weatherRepository = WeatherRepository();

  @override
  Future<Option<Activity>> findOneByID(
    int id, {
    DatabaseExecutor? executor,
  }) async {
    executor ??= super.dbClient;
    var rawResults = await executor.query(
      tableName,
      where: "id=?",
      whereArgs: [id],
    );
    if (rawResults.isEmpty) {
      return None();
    }

    
    var rawResult = rawResults.first;
    var modifiableRawResult=Map.of(rawResult);
    var category=await categoryRepository.findOneByID(rawResult["category_id"] as int,executor: executor);
    modifiableRawResult["category"]=category.unwrap();
    var location=await locationRepository.findByActivityID(id,executor: executor);
    modifiableRawResult["location"]=location.unwrap();
    var evidence = await evidenceRepository.findByActivityID(id, executor: executor);
    switch (evidence){
      case Some(value:var ev): 
            modifiableRawResult["evidence"]=ev;
            break;
      case None():
            modifiableRawResult["evidence"]=null;
            break;
    }

    var weather=await weatherRepository.findByActivityID(id,executor: executor);
    modifiableRawResult["weather"]=weather.unwrap();
    var result = fromResult(modifiableRawResult);
    return Some(result);
  }

  @override
  Future<Activity> saveOne(
    Activity activity, {
    DatabaseExecutor? executor,
  }) async {
    executor ??= super.dbClient;

    late Activity saved;
    try {
      var transaction = await executor.database.transaction((tx) async {
        var categoryPersist = activity.category;
        if (categoryPersist.id == 0) {
          categoryPersist = await categoryRepository.saveOne(
            activity.category,
            executor: tx,
          );
          activity.category = categoryPersist;
        }

        print(activity.category.id);

        var saveID = await tx.insert(tableName, activity.toJSon());

        //saved = (await findOneByID(saveID,executor:tx)).unwrap();

      

        activity.location.activityID = saveID;
        var locationPersist = await locationRepository.saveOne(
          activity.location,
          executor: tx,
        );
        //saved.location = locationPersist;

        EvidenceImage? imagePersist;
        if (activity.evidence != null) {
          imagePersist!.activityID = saveID;
          imagePersist = await evidenceRepository.saveOne(
            activity.evidence!,
            executor: tx,
          );
          //saved.evidence = imagePersist;
        }

        activity.weather.activityID = saveID;
        Weather weatherPersist = await weatherRepository.saveOne(
          activity.weather,
          executor: tx
        );
        //saved.weather = weatherPersist;
        saved = (await findOneByID(saveID,executor:tx)).unwrap();
      });

      

      return saved;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Result<Activity, Exception>> update(
    Activity activity, {
    DatabaseExecutor? executor,
  }) async {
    try {
      if (executor != null) {
        throw UnsupportedParamException(
          "executor",
          "need to start a transaction",
        );
      }
      if (activity.id == 0) {
        return Err(NoIDException());
      }
      var existingOption = await findOneByID(activity.id);
      if (existingOption.isNone()) {
        return Err(UnregisteredComponentException.unregistered("Activity"));
      }
      var existing = existingOption.unwrap();
      late Activity saved;
      var transaction = await super.dbClient.transaction((tx) async {
        if (activity.category.id == 0) {
          var newCategory=await categoryRepository.saveOne(activity.category, executor: tx);
          activity.category.id=newCategory.id;
        }
        // if (activity.category.id!=existing.category.id){
          
        // }

        if (activity.date.millisecondsSinceEpoch !=
            existing.date.millisecondsSinceEpoch) {
          //loggear o algo
          activity.date = existing.date;
        }

        if (activity.evidence!=null){
          activity.evidence!.activityID=activity.id;
          await evidenceRepository.saveOne(activity.evidence!,executor: tx);
        }

        // ignore: unused_local_variable
        var result = tx.update(tableName, activity.toJSon(),where: "id=?",whereArgs:[existing.id]);
        saved = (await findOneByID(activity.id, executor: tx)).unwrap();
      });

      return Ok(saved);
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<List<Activity>> findAll({DatabaseExecutor? executor}) async{
    executor??=super.dbClient;
    var foundActivities=await executor.query(tableName,where: "deleted_at IS NULL");
    var activityList=<Activity>[];
    for (var result in foundActivities) {

      activityList.add((await findOneByID(result["id"] as int )).unwrap());
    }
    return activityList;
  }

  Future<Result<void,Exception>> setDeleted(int id,{DatabaseExecutor? executor}) async{
    if (id==0){
      return Err(NoIDException());
    }
    executor??=super.dbClient;
    var found=await findOneByID(id);
    switch (found) {
      case Some(value: var existing):
        existing.deletedAt=DateTime.now();
        return update(existing);
        
      case None():
        return Err(Exception("ID not found"));
    }

  }

  @override
  Activity fromResult(Map<String, Object?> result) {
    int id = result["id"] as int;
    String name = result["name"] as String;
    String description = result["description"] as String;
    double experience = result["experience"] as double;
    int dateAsUnix = result["date"] as int;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dateAsUnix);

    Category category = result["category"] as Category;
    Location location = result["location"] as Location;
    EvidenceImage? evidence = result["evidence"] as EvidenceImage?;
    Weather weather = result["weather"] as Weather;
    int completed = result["completed"] as int;

    return Activity.load(
      id,
      name,
      description,
      location,
      category,
      weather,
      date,
      experience,
      evidence,
      completed,
    );
  }
}
