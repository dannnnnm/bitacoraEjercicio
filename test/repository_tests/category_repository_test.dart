import 'package:bitacora_ejercicios/model/category.dart';
import 'package:bitacora_ejercicios/repository/category_repository.dart';
import 'package:bitacora_ejercicios/service/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

void main() {
  late CategoryRepository categoryRepository;
  Future<void> beforeEach() async {
    sqfliteFfiInit();
    await DatabaseService.init(
      customDB: await databaseFactoryFfi.openDatabase(":memory:"),
    );
    categoryRepository = CategoryRepository();
  }

  ;

  setUp(beforeEach);
  tearDown(() async {
    DatabaseService.getDbClient().close();
  });

  test("usar save genera una id", () async {
    Category category = Category("cardio");
    var saved = await categoryRepository.saveOne(category);

    expect(saved.id, isNot(0));
  });

  test("usar save mas de una vez genera una id incrementada", () async {
    Category category = Category("cardio");
    Category category2 = Category("hiking");
    var saved = await categoryRepository.saveOne(category);
    var saved2 = await categoryRepository.saveOne(category2);

    expect(saved2.id, 2);
  });

  test("usar save guarda datos iguales a los usados", () async {
    Category category = Category("cardio");
    var saved = await categoryRepository.saveOne(category);
    var savedJson = saved.toJson();
    savedJson.remove("id");
    expect(category.toJson(), savedJson);
  });

  test("usar save mas de una vez guarda datos distintos entre si", () async {
    Category category = Category("cardio");
    Category category2 = Category("hiking");
    var saved = await categoryRepository.saveOne(category);
    var saved2 = await categoryRepository.saveOne(category2);

    expect(saved.toJson(), isNot(saved2.toJson()));
  });
}
