import 'package:bitacora_ejercicios/model/activity.dart';
import 'package:bitacora_ejercicios/model/category.dart';
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
}