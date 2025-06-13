import 'package:bitacora_ejercicios/model/category.dart';
import 'package:bitacora_ejercicios/model/location.dart';
import 'package:bitacora_ejercicios/repository/category_repository.dart';
import 'package:bitacora_ejercicios/repository/location_repository.dart';
import 'package:bitacora_ejercicios/repository/weather_repository.dart';
import 'package:bitacora_ejercicios/service/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

void main() {
  late LocationRepository locationRepository;
  late CategoryRepository categoryRepository;
  Future<void> beforeEach() async {
    sqfliteFfiInit();
    await DatabaseService.init(
      customDB: await databaseFactoryFfi.openDatabase(":memory:"),
    );
    locationRepository = LocationRepository();
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

  test("guardar 1 agrega id", () async {
    Location location = Location(latitude: 20.0014, longitude: 23.45354);
    location.activityID = 1;
    var saved = await locationRepository.saveOne(location);
    expect(saved.id, isNot(0));
  });

  test("guardar 2 incrementa id", () async {
    Location location = Location(latitude: 20.0014, longitude: 23.45354);
    Location location2 = Location(latitude: 204.0014, longitude: 3.45354);
    location.activityID = 1;
    location2.activityID = 2;
    var saved = await locationRepository.saveOne(location);
    var saved2 = await locationRepository.saveOne(location2);
    expect(saved2.id, 2);
  });

  test("guardar 2 guarda datos distintos", () async {
    Location location = Location(latitude: 20.0014, longitude: 23.45354);
    Location location2 = Location(latitude: 204.0014, longitude: 3.45354);
    location.activityID = 1;
    location2.activityID = 2;
    var saved = await locationRepository.saveOne(location);
    var saved2 = await locationRepository.saveOne(location2);
    expect(saved2.toJson(),isNot(saved.toJson()));
  });

  test("guardar mantiene los datos", () async {
    Location location = Location(latitude: 20.0014, longitude: 23.45354);
    location.activityID = 1;
    var saved = await locationRepository.saveOne(location);
    var savedJson = saved.toJson();
    savedJson.remove("id");
    expect(savedJson, location.toJson());
  });

  test("actualizar mantiene los datos", () async {
    Location location = Location(latitude: 20.0014, longitude: 23.45354);
    location.activityID = 1;
    var saved = await locationRepository.saveOne(location);
    saved.longitude=0.1;
    saved.latitude=55.4;
    var updated=(await locationRepository.update(saved)).unwrap();
    
    expect(updated.toJson(), saved.toJson());
  });
}
