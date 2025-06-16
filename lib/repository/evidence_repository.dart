import 'package:bitacora_ejercicios/exception/no_id_exception.dart';
import 'package:bitacora_ejercicios/model/evidence_image.dart';
import 'package:bitacora_ejercicios/repository/base_repository.dart';
import 'package:bitacora_ejercicios/utilTypes/option.dart';
import 'package:bitacora_ejercicios/utilTypes/result.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';


typedef EvidenceImageResultMap=Map<String,Object?>;
class EvidenceRepository extends BaseRepository<EvidenceImage,Exception>{
  EvidenceRepository():super("evidence");
  @override
  Future<EvidenceImage> saveOne(EvidenceImage evidence, {DatabaseExecutor? executor}) async{
    executor??=super.dbClient;
    int lastId=await executor.insert(tableName, evidence.toJson());
    EvidenceImage savedEvidence=(await findOneByID(lastId,executor: executor)).unwrap();
    return savedEvidence;
  }

  @override
  Future<Option<EvidenceImage>> findOneByID(int id, {DatabaseExecutor? executor}) async {
    if (id==0){
      return None();
    }
    executor??=super.dbClient;
    List<EvidenceImageResultMap> found = await executor.query(tableName,where: "id=?",whereArgs: [id]);
    if (found.isEmpty){
      return None();
    }
    var category=fromResult(found.first);
    return Some(category);
  }

  @override
  EvidenceImage fromResult(EvidenceImageResultMap result){
    int id=result["id"] as int;
    int activityID=result["activity_id"] as int;
    Uint8List bytes=result["image_bytes"] as Uint8List;
    return EvidenceImage.load(id,activityID ,bytes);
  }

  @override
  Future<Result<EvidenceImage, Exception>> update(EvidenceImage evidence, {DatabaseExecutor? executor}) async{
    if (evidence.id==0){
      Err(NoIDException());
    }
    executor??=super.dbClient;
    // ignore: unused_local_variable
    var result=await executor.update(tableName, evidence.toJson(),where: "id=?",whereArgs: [evidence.id]);
    var found=await findOneByID(evidence.id);
    return Ok(found.unwrap());
  }

  Future<Option<EvidenceImage>> findByActivityID(
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

    EvidenceImageResultMap result = results.first;
    var location = fromResult(result);
    return Some(location);
  }

}