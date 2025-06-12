import 'package:bitacora_ejercicios/model/category.dart';
import 'package:bitacora_ejercicios/model/weather.dart';
import 'package:bitacora_ejercicios/repository/category_repository.dart';
import 'package:bitacora_ejercicios/repository/weather_repository.dart';
import 'package:bitacora_ejercicios/service/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

void main() {
  late WeatherRepository weatherRepository;
  late CategoryRepository categoryRepository;
  Future<void> beforeEach() async {
    sqfliteFfiInit();
    await DatabaseService.init(
      customDB: await databaseFactoryFfi.openDatabase(":memory:"),
    );
    weatherRepository = WeatherRepository();
    categoryRepository = CategoryRepository();
    await categoryRepository.saveOne(Category("testCat"));
    await categoryRepository.saveOne(Category("testCat2"));
    var activity1 = {
      "name": "act1",
      "date": DateTime.now().millisecondsSinceEpoch,
      "description": "desc",
      "experience": 10.5,
      "completed": 0,
      "category_id": 1,
    };
    var activity2 = {
      "name": "act2",
      "date": DateTime.now().millisecondsSinceEpoch + 5000,
      "description": "desc2",
      "experience": 12.5,
      "completed": 1,
      "category_id": 2,
    };
    await DatabaseService.getDbClient().insert("activity", activity1);
    await DatabaseService.getDbClient().insert("activity", activity2);
  }

  ;

  setUp(beforeEach);
  tearDown(() async {
    DatabaseService.getDbClient().close();
  });

  test("insertar registro de clima le entrega una id", () async {
    Weather weather = Weather.simple(
      "RAINY",
      "Real rain, like, from the sky to the ground",
      20,
    );
    weather.activityID = 1;
    var saved = await weatherRepository.saveOne(weather);
    expect(saved.id, isNot(0));
  });

  test("Insertar registro de clima mantiene detalles", () async {
    Weather weather = Weather.simple(
      "RAINY",
      "Real rain, like, from the sky to the ground",
      20,
    );
    weather.activityID = 1;
    var saved = await weatherRepository.saveOne(weather);
    var savedJson = saved.toDBJson();
    savedJson.remove("id");
    expect(savedJson, weather.toDBJson());
  });

  test("Insertar 2 incrementa la id", () async {
    var w1 = Weather.simple("RAINY", "REAL MOIST", 2.1);
    var w2 = Weather.simple("HOT", "desertic", 100.2);
    w1.activityID = 1;
    w2.activityID = 2;
    var saved1 = await weatherRepository.saveOne(w1);
    var saved2 = await weatherRepository.saveOne(w2);
    expect(saved2.id, 2);
  });

  test("Guardar guarda la id de actividad", () async {
    var w1 = Weather.simple("RAINY", "REAL MOIST", 2.1);
    var w2 = Weather.simple("HOT", "desertic", 100.2);
    w1.activityID = 2;
    w2.activityID = 1;
    var saved1 = await weatherRepository.saveOne(w1);
    var saved2 = await weatherRepository.saveOne(w2);
    expect(saved2.activityID, 1);
  });

  test("Guardar 2 guarda diferentes", () async {
    var w1 = Weather.simple("RAINY", "REAL MOIST", 2.1);
    var w2 = Weather.simple("HOT", "desertic", 100.2);
    w1.activityID = 2;
    w2.activityID = 1;
    var saved1 = await weatherRepository.saveOne(w1);
    var saved2 = await weatherRepository.saveOne(w2);
    expect(saved2.toDBJson(), isNot(saved1.toDBJson()));
  });

  test("Guardar 2 full guarda diferentes", () async {
    var w1 = Weather("RAINY", "REAL MOIST", 2.1, 0.1, 4.5, 200);
    var w2 = Weather("HOT", "desertic", 100.2, 4.5, 200.5, 100);
    w1.activityID = 2;
    w2.activityID = 1;
    var saved1 = await weatherRepository.saveOne(w1);
    var saved2 = await weatherRepository.saveOne(w2);
    expect(saved2.toDBJson(), isNot(saved1.toDBJson()));
  });

  test("Guardar full guarda lo mismo", () async {
    var w1 = Weather("RAINY", "REAL MOIST", 2.1, 0.1, 4.5, 200);
    w1.activityID = 2;
    var saved1 = await weatherRepository.saveOne(w1);
    var savedjson = saved1.toDBJson();
    savedjson.remove("id");
    expect(w1.toDBJson(), savedjson);
  });
}
