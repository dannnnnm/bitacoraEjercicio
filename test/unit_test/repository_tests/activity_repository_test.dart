import 'dart:typed_data';

import 'package:bitacora_ejercicios/model/activity.dart';
import 'package:bitacora_ejercicios/model/category.dart';
import 'package:bitacora_ejercicios/model/evidence_image.dart';
import 'package:bitacora_ejercicios/model/location.dart';
import 'package:bitacora_ejercicios/model/weather.dart';
import 'package:bitacora_ejercicios/repository/activity_repository.dart';
import 'package:bitacora_ejercicios/service/database_service.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

void main(){
  late ActivityRepository activityRepository;
  Future<void> beforeEach() async {
    sqfliteFfiInit();
    await DatabaseService.init(
      customDB: await databaseFactoryFfi.openDatabase(":memory:"),
    );
    activityRepository = ActivityRepository();
  }

  setUp(beforeEach);
  tearDown(() async {
    DatabaseService.getDbClient().close();
  });

  test("Guardar actividad no lanza excepcion", () async{
    Activity activity = Activity(
      "Caminar",
      "Salir a caminar",
      Location(latitude: 0.21, longitude: 0.22),
      Category("Piernas"),
      Weather.simple("RAINY", "Slightly rainy. Maybe frogs", 10.6),
      35.0,
    );
    
    testedFun() async{
      var res=await activityRepository.saveOne(activity);
      print(res);
    }

    try{
      await testedFun();
    }
    catch(e){
      fail("threw exception $e");
    }

  });

  test("Recuperar conserva detalles",() async{
    Activity activity = Activity(
      "Caminar",
      "Salir a caminar",
      Location(latitude: 0.21, longitude: 0.22),
      Category("Piernas"),
      Weather.simple("RAINY", "Slightly rainy. Maybe frogs", 10.6),
      35.0,
    );

    var saved=await activityRepository.saveOne(activity);

    activity.id=saved.id;
    activity.category.id=saved.category.id;
    activity.weather.id=saved.weather.id;
    activity.weather.activityID=saved.weather.activityID;
    activity.location.id=saved.location.id;
    activity.location.activityID=saved.location.activityID;
    expect(saved.toJSon(), activity.toJSon());
  });

  test("Recuperar conserva detalles",() async{
    Activity activity = Activity(
      "Caminar",
      "Salir a caminar",
      Location(latitude: 0.21, longitude: 0.22),
      Category("Piernas"),
      Weather.simple("RAINY", "Slightly rainy. Maybe frogs", 10.6),
      35.0,
    );

    Activity activity2 = Activity(
      "Correr",
      "Salir a correr",
      Location(latitude: 5.21, longitude: 0.232),
      Category("Piernas"),
      Weather.simple("RAINY", "Slightly rainy. Maybe frogs", 10.2),
      36.0,
    );

    var saved=await activityRepository.saveOne(activity);

    var saved2=await activityRepository.saveOne(activity2);
    expect(saved2.toJSon(), isNot(saved.toJSon()));
  });


  test("Recuperar todos ignora borrados",() async{
    Activity activity = Activity(
      "Caminar",
      "Salir a caminar",
      Location(latitude: 0.21, longitude: 0.22),
      Category("Piernas"),
      Weather.simple("RAINY", "Slightly rainy. Maybe frogs", 10.6),
      35.0,
    );

    Activity activity2 = Activity(
      "Correr",
      "Salir a correr",
      Location(latitude: 5.21, longitude: 0.232),
      Category("Piernas"),
      Weather.simple("RAINY", "Slightly rainy. Maybe frogs", 10.2),
      36.0,
    );

    var saved=await activityRepository.saveOne(activity);

    var saved2=await activityRepository.saveOne(activity2);
    var deleteResult=await activityRepository.setDeleted(saved2.id);
    if (deleteResult.isErr()){
      fail("failed to delte with ${deleteResult}");
    }
    var all=await activityRepository.findAll();
    expect(all.length, inExclusiveRange(0, 2));
  });


  test("Guardar agrega evidencia mas tarde",() async{
    Activity activity = Activity(
      "Caminar",
      "Salir a caminar",
      Location(latitude: 0.21, longitude: 0.22),
      Category("Piernas"),
      Weather.simple("RAINY", "Slightly rainy. Maybe frogs", 10.6),
      35.0,
    );


    var saved=await activityRepository.saveOne(activity);

    saved.evidence=EvidenceImage(Uint8List.fromList([1,32,42]));
    var savedUpdated=(await activityRepository.update(saved)).unwrap();
    expect(savedUpdated.evidence, isNot(null));
  });


  
}